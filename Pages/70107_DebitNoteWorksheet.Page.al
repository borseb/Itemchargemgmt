page 70107 DebitNoteWorksheet
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    ModifyAllowed = true;
    // DeleteAllowed = false;
    SourceTable = DebitNoteWorksheetKPMG;
    Caption = 'Debit Note Worksheet';
    // SourceTableView = where(Status = filter('Pending'));

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                ShowCaption = false;
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Sales Shipment No."; Rec."Sales Shipment No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Promised Delivery Date"; Rec."Promised Delivery Date")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Location Type"; Rec."Location Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Total Days"; Rec."Total Days")
                {
                    ApplicationArea = All;
                }
                field("Total Months"; Rec."Total Months")
                {
                    ApplicationArea = All;
                }
                field("Charge per month"; Rec."Charge per month")
                {
                    ApplicationArea = All;
                }
                field("0-30Days"; Rec."0-30Days")
                {
                    ApplicationArea = All;
                }
                field("31-60Days"; Rec."31-60Days")
                {
                    ApplicationArea = All;
                }
                field("61-90Days"; Rec."61-90Days")
                {
                    ApplicationArea = All;
                }
                field("Total Charges"; Rec."Total Charges")
                {
                    ApplicationArea = All;
                }
                field("Final Charges"; Rec."Final Charges")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(CreateSalesInv)
            {
                ApplicationArea = All;
                Caption = 'Make Debit Note';

                trigger OnAction();
                var
                    DebitNote: Record DebitNoteWorksheetKPMG;
                    SalesInvoice: Record "Sales Header";
                    salesInvLine: Record "Sales Line";
                    InvNo: Code[20];
                    NoSeriesMgm: Codeunit NoSeriesManagement;
                    SalAndReceivalbleSetup: Record "Sales & Receivables Setup";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    LineNo: Integer;

                begin
                    Clear(InvNo);
                    SalAndReceivalbleSetup.Get();
                    DebitNote.SetRange("Sales Order No.", Rec."Sales Order No.");
                    DebitNote.SetRange(Status, DebitNote.Status::Approved);
                    DebitNote.SetFilter("Sales Invoice No.", '%1', '');
                    if DebitNote.FindSet() then begin
                        repeat
                            if DebitNote."Sales Invoice No." = '' then
                                if DebitNote."Total Charges" <> 0 then begin
                                    if InvNo = '' then begin
                                        SalesInvoice.Init();
                                        InvNo := NoSeriesMgm.GetNextNo(SalAndReceivalbleSetup."Invoice Nos.", WorkDate(), true);
                                        SalesInvoice."No." := InvNo;
                                        SalesInvoice."Document Type" := SalesInvoice."Document Type"::Invoice;
                                        SalesInvoice.Validate("Sell-to Customer No.", DebitNote."Customer No.");
                                        // salesInvLine.Validate("Bill-to Customer No.", DebitNote."Customer No.");
                                        SalesInvoice.Validate("Location Code", DebitNote."Location Code");
                                        SalesInvoice."Posting Date" := WorkDate();
                                        SalesInvoice.Insert();
                                    end;
                                    if InvNo <> '' then begin
                                        salesInvLine.Init();
                                        salesInvLine."Document No." := InvNo;
                                        salesInvLine."Document Type" := salesInvLine."Document Type"::Invoice;
                                        if LineNo = 0 then
                                            LineNo := 10000
                                        else
                                            LineNo += 10000;
                                        salesInvLine."Line No." := LineNo;
                                        salesInvLine.Type := salesInvLine.Type::"G/L Account";
                                        salesInvLine.Validate("No.", SalAndReceivalbleSetup."Debit Note Account");
                                        salesInvLine.Validate(Quantity, 1);
                                        salesInvLine.Validate("Unit Price", DebitNote."Final Charges");
                                        salesInvLine.Insert();
                                    end;


                                    DebitNote."Sales Invoice No." := InvNo;
                                    DebitNote.Modify();
                                end;

                        until DebitNote.Next() = 0;
                        Clear(SalesInvoice);
                        SalesInvoice.SetRange("No.", InvNo);
                        if SalesInvoice.FindFirst() then begin
                            if ApprovalsMgmt.CheckSalesApprovalPossible(SalesInvoice) then
                                ApprovalsMgmt.OnSendSalesDocForApproval(SalesInvoice);
                        end;
                        Message('Sales Invoice no. is %1', InvNo);
                    end;
                end;
            }
            action(ApproveDebitNote)
            {
                ApplicationArea = All;
                Caption = 'Approve Debit Note';

                trigger OnAction()
                var
                    DebitNote: Record DebitNoteWorksheetKPMG;
                    UserSetup: Record "User Setup";
                begin
                    UserSetup.SetRange("User ID", UserId);
                    if UserSetup.FindFirst() then
                        if UserSetup."Trade Member" then begin
                            DebitNote.SetRange("Sales Order No.", Rec."Sales Order No.");
                            DebitNote.SetRange("Sales Shipment No.", Rec."Sales Shipment No.");
                            DebitNote.SetRange("Item Category Code", Rec."Item Category Code");
                            DebitNote.SetRange(Quantity, Rec.Quantity);
                            DebitNote.SetRange("Total Charges", Rec."Total Charges");
                            if DebitNote.FindFirst() then begin
                                DebitNote.Status := DebitNote.Status::Approved;
                                DebitNote.Modify();
                            end;
                        end
                        else
                            Error('You don''t have permission to approve the debit note. Please review it.');

                end;
            }
            action(RejectDebitNote)
            {
                ApplicationArea = All;
                Caption = 'Reject Debit Note';

                trigger OnAction()
                var
                    DebitNote: Record DebitNoteWorksheetKPMG;
                    UserSetup: Record "User Setup";
                begin
                    UserSetup.SetRange("User ID", UserId);
                    if UserSetup.FindFirst() then
                        if UserSetup."Trade Member" then begin
                            DebitNote.SetRange("Sales Order No.", Rec."Sales Order No.");
                            DebitNote.SetRange("Sales Shipment No.", Rec."Sales Shipment No.");
                            DebitNote.SetRange("Item Category Code", Rec."Item Category Code");
                            DebitNote.SetRange(Quantity, Rec.Quantity);
                            DebitNote.SetRange("Total Charges", Rec."Total Charges");
                            if DebitNote.FindFirst() then begin
                                DebitNote.Status := DebitNote.Status::Rejected;
                                DebitNote.Modify();
                            end;



                        end
                        else
                            Error('You don''t have permission to reject the debit note. Please review it.');

                end;
            }
        }
    }
}
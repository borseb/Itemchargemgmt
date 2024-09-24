page 70108 "Open Provision List"
{
    ApplicationArea = All;
    Caption = 'Open Provision List';
    PageType = List;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTable = "Open Provision";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
                field("Receipt No."; Rec."Receipt No.")
                {
                    ToolTip = 'Specifies the value of the Receipt No. field.', Comment = '%';
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
                }
                field("Item Description"; Rec."Item Description")
                {
                    ToolTip = 'Specifies the value of the Item Description field.', Comment = '%';
                }

                field("PO No."; Rec."PO No.")
                {
                    ToolTip = 'Specifies the value of the PO No. field.', Comment = '%';
                }
                field("BPO No."; Rec."BPO No.")
                {
                    ToolTip = 'Specifies the value of the BPO No. field.', Comment = '%';
                }

                field("Posted Provision"; Rec."Posted Provision")
                {
                    ToolTip = 'Specifies the value of the Posted Provision field.', Comment = '%';
                }
                field("Reversed Provision"; Rec."Reversed Provision")
                {
                    ToolTip = 'Specifies the value of the Reversed Provision field.', Comment = '%';
                }
                field("Provision Reverse"; Rec."Provision Reverse")
                {
                    ToolTip = 'Specifies the value of the Provision Reverse field.', Comment = '%';
                }
                field(Commodity; Rec.Commodity)
                {
                    ToolTip = 'Specifies the value of the Commodity field.', Comment = '%';
                }


                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                }

                field("Remaning Open Provision"; Rec."Remaning Open Provision")
                {
                    ToolTip = 'Specifies the value of the Remaning Open Provision field.', Comment = '%';
                }
                field("Transporter Code"; Rec."Transporter Code")
                {

                }
                field("Transporter Name"; Rec."Transporter Name")
                {

                }

                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(UpdateProvision)
            {
                ApplicationArea = All;
                Image = UpdateDescription;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                trigger OnAction()
                var
                    Purreceiptline: Record "Purch. Rcpt. Line";
                    PurchLine: Record "Purchase Line";
                    Purchhdr: Record "Purchase Header";
                    PurchReceiptHdr: Record "Purch. Rcpt. Header";
                    Dimn: Record "Dimension Set Entry";
                    ILE: Record "Item Ledger Entry";
                begin

                    Purreceiptline.Reset();
                    Purreceiptline.SetRange(Type, Purreceiptline.Type::Item);
                    //Purreceiptline.SetFilter("Document No.", '<>%1', Rec."Receipt No.");
                    Purreceiptline.SetRange("Document No.", Rec."Receipt No.");
                    if not Purreceiptline.FindSet() then
                        repeat
                            Openpro.Init();
                            Openpro."Receipt No." := Purreceiptline."Document No.";
                            Openpro."Line No." := Purreceiptline."Line No.";
                            Openpro."BPO No." := Purreceiptline."Blanket Order No.";
                            if PurchReceiptHdr.Get(Purreceiptline."Document No.") then
                                Openpro."PO No." := PurchReceiptHdr."Order No.";
                            Openpro."Item No." := Purreceiptline."No.";
                            Openpro."Item Description" := Purreceiptline.Description;
                            Openpro."Posting Date" := Purreceiptline."Posting Date";
                            Dimn.Reset();
                            Dimn.SetRange("Dimension Code", 'Commodity');
                            Dimn.SetRange("Dimension Set ID", Purreceiptline."Dimension Set ID");
                            if Dimn.FindFirst() then
                                Openpro.Commodity := Dimn."Dimension Value Code";
                            Openpro.Quantity := Purreceiptline.Quantity;
                            Openpro."Location Code" := Purreceiptline."Location Code";
                            ILE.Reset();
                            ILE.SetRange("Entry Type", ILE."Entry Type"::Purchase);
                            ILE.SetRange("Document Type", ile."Document Type"::"Purchase Receipt");
                            ILE.SetRange("Posting Date", Purreceiptline."Posting Date");
                            ILE.SetRange("Document No.", Purreceiptline."Document No.");
                            if ILE.FindFirst() then
                                Openpro."Item Ledger Entry No" := ILE."Entry No.";
                            Openpro.Insert();
                        //if OPlist.FindLast() then
                        //   Openpro."Line No." := OPlist."Line No." + 10000
                        //else
                        //  OPlist."Line No." := 10000;

                        until Purreceiptline.Next = 0;
                end;
            }
            action(reverseProvision)
            {
                Caption = 'Reverse Provision';
                ApplicationArea = All;
                Image = ReverseLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                begin
                    Openprov.Reset();
                    Openprov.SetRange("Receipt No.", Rec."Receipt No.");
                    reverseprovReport.SetTableView(Openprov);
                    Commit();
                    reverseprovReport.RunModal();

                end;
            }
            action(ValueEntries)
            {
                ApplicationArea = All;
                Caption = 'Value Entries';

                trigger OnAction()
                var
                    valueentries: Record "Value Entry";
                    valueentrpage: Page "Value Entries";
                begin
                    valueentries.Reset();
                    valueentries.SetRange("Item Ledger Entry No.", Rec."Item Ledger Entry No");
                    valueentrpage.SetTableView(valueentries);
                    valueentrpage.Run();
                end;
            }
            action(testRun)
            {
                ApplicationArea = All;
                Caption = 'Test Codeunit';

                trigger OnAction()
                var
                    valueentries: Record "Value Entry";
                    openreverse: Codeunit 70105;
                begin
                    openreverse.Run(Rec);
                end;
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    var

    begin
        if Rec."Provision Reverse" then
            Isreportrun := false
        else
            Isreportrun := true;
    end;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        Rec.CalcFields("Reversed Provision", "Posted Provision");
        Rec."Remaning Open Provision" := Abs(Rec."Posted Provision" + Rec."Reversed Provision");
        Rec.Modify();
        if Rec."Provision Reverse" then
            Isreportrun := false
        else
            Isreportrun := true;
    end;

    var
        Openpro: Record "Open Provision";
        reverseprovReport: Report "Reverse Provision Creation";
        Openprov: Record "Open Provision";
        Isreportrun: Boolean;

}

report 70101 "Reverse Provision Creation"
{
    ApplicationArea = All;
    Caption = 'Reverse Provision Creation';
    UsageCategory = Lists;
    ProcessingOnly = true;
    dataset
    {
        dataitem(OpenProvision; "Open Provision")
        {
            DataItemTableView = where("Provision Reverse" = filter(false));
            RequestFilterFields = "Receipt No.";
            column(ItemLedgerEntryNo; "Item Ledger Entry No")
            {
            }
            column(ItemNo; "Item No.")
            {
            }
            column(LineNo; "Line No.")
            {
            }
            column(LocationCode; "Location Code")
            {
            }
            column(PostingDate; "Posting Date")
            {
            }
            column(ProvisionReverse; "Provision Reverse")
            {
            }
            column(Quantity; Quantity)
            {
            }
            column(ReceiptNo; "Receipt No.")
            {
            }
            dataitem("Value Entry"; "Value Entry")
            {
                DataItemLink = "Item Ledger Entry No." = field("Item Ledger Entry No");
                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                    ILE: Record "Item Ledger Entry";
                begin
                    "Value Entry".CalcFields("Charge(Item) Type KPMG", "Charge(Item) Type KPMG CR");
                    if ("Value Entry"."Charge(Item) Type KPMG" = "Value Entry"."Charge(Item) Type KPMG"::" ") then
                        CurrReport.Skip();
                    PurchAndPayableSetup.Get();
                    valueEntry.Reset();
                    valueEntry.SetRange("Item Charge No.", "Value Entry"."Item Charge No.");
                    //valueEntry.SetFilter("Charge(Item) Type KPMG CR",'<>%1',);
                    valueEntry.SetRange("Item Ledger Entry No.", "Value Entry"."Item Ledger Entry No.");
                    valueEntry.SetRange("Charge(Item) Type KPMG CR", valueEntry."Charge(Item) Type KPMG CR"::Provisional);
                    if not valueEntry.FindFirst() then begin
                        Clear(PurchHeader_Rec);
                        if ILE.Get(OpenProvision."Item Ledger Entry No") then;
                        PurchHeader_Rec.Init();
                        CrMemoNo := NoSeriesMgm.GetNextNo(PurchAndPayableSetup."Credit Memo Nos.", WorkDate(), true);
                        PurchHeader_Rec."No." := CrMemoNo;
                        PurchHeader_Rec."Document Type" := PurchHeader_Rec."Document Type"::"Credit Memo";
                        if VenCrMemo2 = '' then begin
                            VenCrMemo2 := ILE."Document No.";
                            VenCrMemoNo := ILE."Document No.";
                        end
                        else begin
                            if VenCrMemo2 = ILE."Document No." then begin
                                i += 1;
                                VenCrMemoNo := ILE."Document No." + Format(i);
                            end
                            else begin
                                VenCrMemoNo := ILE."Document No.";
                                VenCrMemo2 := ILE."Document No.";
                            end;
                        end;
                        //>> BRB_KPMG_20012024

                        PurchHeader_Rec.Validate("Buy-from Vendor No.", "Value Entry"."Source No.");
                        PurchHeader_Rec.Validate("Posting Date", Today);
                        PurchHeader_Rec."Vendor Cr. Memo No." := VenCrMemoNo;
                        PurchHeader_Rec.Validate("Location Code", PurchAndPayableSetup."Location Code KPMG");
                        // PurchHeader_Rec."Purchaser Code" := 'NA';
                        PurchHeader_Rec."Charge Item Type KPMG" := PurchHeader_Rec."Charge Item Type KPMG"::Provisional;
                        PurchHeader_Rec.Insert(true);
                        Clear(PurchLine);
                        PurchLine.Init();
                        PurchLine."Document Type" := PurchLine."Document Type"::"Credit Memo";
                        PurchLine."Document No." := CrMemoNo;
                        PurchLine."Line No." := 10000;
                        PurchLine.Type := PurchLine.Type::"Charge (Item)";
                        //PurchLine.Validate("No.", 'FREIGHT');
                        PurchLine.Validate("No.", "Value Entry"."Item Charge No.");
                        PurchLine.Validate(Quantity, "Value Entry"."Valued Quantity");
                        PurchLine.Validate("Direct Unit Cost", "Value Entry"."Cost per Unit");
                        PurchLine.Insert(true);

                        // Item charge

                        Clear(ItemChargeAssignPurchForCrMemo);
                        ItemChargeAssignPurchForCrMemo.Init();
                        ItemChargeAssignPurchForCrMemo."Document Type" := ItemChargeAssignPurchForCrMemo."Document Type"::"Credit Memo";
                        ItemChargeAssignPurchForCrMemo."Document No." := CrMemoNo;
                        ItemChargeAssignPurchForCrMemo.Validate("Document Line No.", 10000);
                        ItemChargeAssignPurchForCrMemo."Line No." := 10000;
                        ItemChargeAssignPurchForCrMemo."Item Charge No." := "Value Entry"."Item Charge No.";
                        ItemChargeAssignPurchForCrMemo.Validate("Applies-to Doc. Type", ItemChargeAssignPurchForCrMemo."Applies-to Doc. Type"::Receipt);
                        ItemChargeAssignPurchForCrMemo.Validate("Applies-to Doc. No.", ILE."Document No.");
                        //ItemChargeAssignPurchForCrMemo."Applies-to Doc. Line No." := ItemChargeAssignPurch."Applies-to Doc. Line No.";
                        ItemChargeAssignPurchForCrMemo."Applies-to Doc. Line No." := ILE."Document Line No.";

                        ItemChargeAssignPurchForCrMemo."Item No." := "Value Entry"."Item No.";
                        ItemChargeAssignPurchForCrMemo.Validate("Qty. to Assign", "Value Entry"."Valued Quantity");
                        ItemChargeAssignPurchForCrMemo.Description := "Value Entry".Description;
                        ItemChargeAssignPurchForCrMemo.Validate("Qty. to Handle", "Value Entry"."Valued Quantity");
                        ItemChargeAssignPurchForCrMemo."Unit Cost" := "Value Entry"."Cost per Unit";

                        ItemChargeAssignPurchForCrMemo."Amount to Assign" := "Value Entry"."Cost Amount (Actual)";
                        ItemChargeAssignPurchForCrMemo."Amount to Handle" := "Value Entry"."Cost Amount (Actual)";

                        ItemChargeAssignPurchForCrMemo.Insert();
                    end;
                    Clear(PurchLine);
                    PurchLine.SetRange("Document No.", CrMemoNo);
                    PurchLine.SetRange("Document Type", PurchLine."Document Type"::"Credit Memo");
                    if PurchLine.FindFirst() then begin
                        // PurchLine.Validate("Qty. to Assign", 1);
                        PurchLine.Modify(true);
                        PurchHeader_Rec.SetRange("No.", CrMemoNo);
                        if PurchHeader_Rec.FindFirst() then
                            CODEUNIT.Run(CODEUNIT::"Purch.-Post", PurchHeader_Rec);
                        OpenProvision."Provision Reverse" := true;
                        //OpenProvision."Posting Date" := Today;
                        PurchCrHdr.Reset();
                        PurchCrHdr.SetRange("Pre-Assigned No.", CrMemoNo);
                        if PurchCrHdr.FindFirst then;
                        // OpenProvision."Reversal Document No" := PurchCrHdr."No.";
                        OpenProvision.Modify();
                    end;
                end;
            }

        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    var
        valueEntry: Record "Value Entry";
        CrMemoNo: Code[20];
        PurchHeader_Rec: Record "Purchase Header";
        PurchAndPayableSetup: Record "Purchases & Payables Setup";
        PurchCrHdr: Record "Purch. Cr. Memo Hdr.";
        ItemChargeAssignPurchForCrMemo: Record "Item Charge Assignment (Purch)";
        PurchLine: Record 39;
        PurchPost: Codeunit 90;
        NoSeriesMgm: Codeunit NoSeriesManagement;
        VenCrMemo2: Code[20];
        VenCrMemoNo: Code[20];
        i: Integer;
}

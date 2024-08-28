report 70100 MachineCost
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'machinecost.rdl';

    dataset
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            DataItemTableView = sorting("Item No.", "Serial No.") where("Document Type" = filter('Purchase Receipt'), "Serial No." = filter(<> ''));
            column(Item_No_; "Item No.") { }
            column(ItemName; ItemName) { }
            column(Serial_No_; "Serial No.") { }
            column(PurchInvNo; PurchInvNo) { }
            column(VendorInvNo; VendorInvNo) { }
            column(ImportValue; ImportValue) { }
            column(ExchangeRate; ExchangeRate) { }
            column(Entry_No_; "Entry No.") { }
            column(PurchValueInv; PurchValueInv) { }


            dataitem("Value Entry"; "Value Entry")
            {
                DataItemLink = "Item Ledger Entry No." = field("Entry No.");
                DataItemTableView = sorting("Posting Date") where("Item Charge No." = filter('CHA'));
                column(Item_Charge_No_; "Item Charge No.")
                {

                }
                column(Description; Description) { }
                column(Cost_Amount__Actual_; "Cost Amount (Actual)") { }
                column(Item_Ledger_Entry_No_; "Item Ledger Entry No.") { }
            }

            trigger OnAfterGetRecord()
            var
                Item_Rec: Record Item;
                ValueEntry: Record "Value Entry";
                PurchInvHdr: Record "Purch. Inv. Header";
            begin
                ItemName := '';
                PurchInvNo := '';
                VendorInvNo := '';
                ExchangeRate := 0;
                ImportValue := 0;
                PurchValueInv := 0;
                Clear(ValueEntry);
                Clear(PurchInvHdr);
                if Item_Rec.Get("Item No.") then
                    ItemName := Item_Rec.Description;

                ValueEntry.SetRange("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
                ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Purchase Invoice");
                ValueEntry.SetFilter("Item Charge No.", '%1', '');
                if ValueEntry.FindFirst() then begin
                    PurchInvHdr.SetRange("No.", ValueEntry."Document No.");
                    if PurchInvHdr.FindFirst() then;
                    VendorInvNo := PurchInvHdr."Vendor Invoice No.";
                    PurchInvNo := PurchInvHdr."No.";
                    ExchangeRate := 1 / PurchInvHdr."Currency Factor";

                end;

                ValueEntry.Reset();
                ValueEntry.SetRange("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
                ValueEntry.SetFilter("Item Charge No.", '<>%1', 'CHA');
                if ValueEntry.FindSet() then
                    repeat
                        if ExchangeRate <> 1 then
                            ImportValue += ValueEntry."Cost Amount (Actual)" / PurchInvHdr."Currency Factor"
                        else
                            ImportValue += ValueEntry."Cost Amount (Actual)";

                    until ValueEntry.Next() = 0;
                if ExchangeRate <> 1 then
                    PurchValueInv := ImportValue * ExchangeRate
                else
                    PurchValueInv := ImportValue;

            end;
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
                    field(SerialNo; SerialNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Serial No.';

                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        SerialNo: Code[30];
        ItemName: Text;
        PurchInvNo: Code[20];
        VendorInvNo: Code[20];
        ImportValue: Decimal;
        ExchangeRate: Decimal;
        PurchValueInv: Decimal;
}
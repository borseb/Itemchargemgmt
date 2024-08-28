report 70101 "Reverse Provision Creation"
{
    ApplicationArea = All;
    Caption = 'Reverse Provision Creation';
    UsageCategory = Lists;
    dataset
    {
        dataitem(OpenProvision; "Open Provision")
        {
            DataItemTableView = where("Provision Reverse" = filter(false));
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
                begin

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
}

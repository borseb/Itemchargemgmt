query 70100 ItemChargeAssgnPurchKPMG
{
    QueryType = Normal;

    elements
    {
        dataitem(Item_Charge_Assignment__Purch_; "Item Charge Assignment (Purch)")
        {

            column(Applies_to_Doc__No_; "Applies-to Doc. No.")
            {

            }
            column(Applies_to_Doc__Type; "Applies-to Doc. Type") { }
            column(Document_No_; "Document No.") { }
            column(Qty__to_Assign; "Qty. to Assign")
            {
                Method = Sum;
            }
        }
    }

    var
        myInt: Integer;

    trigger OnBeforeOpen()
    begin

    end;
}
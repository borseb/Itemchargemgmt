query 70101 SalesLine
{
    QueryType = Normal;
    Caption = 'SalesLineKPMG';

    elements
    {
        dataitem(Sales_Line; "Sales Line")
        {
            column(Item_Category_Code; "Item Category Code")
            {

            }
            column(Document_No_; "Document No.") { }
            column(Document_Type; "Document Type") { }
            column(Quantity; Quantity)
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
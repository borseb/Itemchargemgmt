tableextension 70118 "70117_PurchLine" extends "Purchase Line"
{
    fields
    {
        field(70100; "Original Contract Qty"; Decimal)
        {
            Caption = '';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                Validate(Quantity, "Original Contract Qty");
            end;
        }
        field(70101; "Original PO Qty"; Decimal)
        {
            Caption = '';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                Validate(Quantity, "Original PO Qty");
            end;
        }
    }
}

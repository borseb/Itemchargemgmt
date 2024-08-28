tableextension 70104 PurchHeaderKPMG extends "Purchase Header"
{
    fields
    {
        modify("Buy-from Vendor Name")
        {
            trigger OnAfterValidate()
            var
                Vend: Record Vendor;
            begin
                if Vend.get("Buy-from Vendor No.") then
                    Rec."Charge Item Type KPMG" := Vend."Charge Item Type KPMG";
            end;
        }
        field(70100; "Charge Item Type KPMG"; Option)
        {
            OptionMembers = Actual,Provisional;
            OptionCaption = 'Actual,Provisional';
            Caption = 'Charge(Item) Type';
            DataClassification = CustomerContent;
        }
        field(70101; "Provisional Inv"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}
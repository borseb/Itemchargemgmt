tableextension 70105 PuchRcptHeaderKPMG extends "Purch. Inv. Header"
{
    fields
    {
        field(70100; "Charge Item Type KPMG"; Option)
        {
            OptionMembers = Actual,Provisional;
            OptionCaption = 'Actual,Provisional';
            Caption = 'Charge(Item) Type';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    var
        myInt: Integer;
}
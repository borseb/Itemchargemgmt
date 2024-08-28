tableextension 70107 PurchCrMemoHeaderKPMG extends "Purch. Cr. Memo Hdr."
{
    fields
    {
        field(70100; "Charge Item Type KPMG"; Option)
        {
            OptionMembers = Actual,Provisional;
            OptionCaption = 'Actual,Provisional';
            Caption = 'Charge(Item) Type';
            DataClassification = CustomerContent;
        }
    }

    var
        myInt: Integer;
}
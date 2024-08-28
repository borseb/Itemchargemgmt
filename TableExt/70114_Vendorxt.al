tableextension 70114 Vendor_ExtKPMG extends Vendor
{
    fields
    {
        field(70100; "Charge Item Type KPMG"; Option)
        {
            // OptionMembers = " ",Provisional;
            //OptionCaption = ' ,Provisional';
            OptionMembers = Actual,Provisional;
            OptionCaption = 'Actual,Provisional,';
            Caption = 'Charge(Item) Type';
            DataClassification = CustomerContent;
        }

    }

    var
        myInt: Integer;
}
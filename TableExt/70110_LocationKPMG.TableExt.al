tableextension 70110 LocationMaster extends Location
{
    fields
    {
        field(70100; "Location Type KPMG"; Option)
        {
            Caption = 'Location Type';
            OptionMembers = Warehouse,Port;
            OptionCaption = 'Warehouse,Port';
        }
    }

    var
        myInt: Integer;
}
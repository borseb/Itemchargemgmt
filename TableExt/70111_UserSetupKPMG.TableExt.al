tableextension 70111 UserSetupKPMG extends "User Setup"
{
    fields
    {
        field(70100; "Trade Member"; Boolean)
        {
            Caption = 'Trade Member';
            DataClassification = CustomerContent;
        }
    }

    var
        myInt: Integer;
}
tableextension 70109 PurchAndPayableSetupKPMG extends "Purchases & Payables Setup"
{
    fields
    {
        field(70100; "Provisional Vendor No."; Code[20])
        {
            Caption = 'Provisional Vendor No.';
            TableRelation = Vendor;
            DataClassification = CustomerContent;
        }
        field(70101; "Location Code KPMG"; Code[20])
        {
            Caption = 'Provisional Location Code';
            TableRelation = Location;
            DataClassification = CustomerContent;
        }
    }

    var
        myInt: Integer;
}
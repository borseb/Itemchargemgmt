tableextension 70101 GenLedEntriesKPMG extends 17
{
    fields
    {
        field(50101; "Vendor Invoice No KPMG"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor Invoice No.';
            // TableRelation = "Purch. Inv. Header"."Vendor Invoice No.";
            Editable = false;
        }
        field(70101; "Provisional Inv"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}
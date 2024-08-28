table 70100 SlabRateKPMG
{
    DataClassification = ToBeClassified;
    Caption = 'Slab Rates for Port';

    fields
    {
        field(70100; "Parent Location code"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Parent Location code';
        }
        field(70101; "0-30Days"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = '0-30 Days';
        }
        field(70102; "31-60Days"; Decimal)
        {
            Caption = '31-60 Days';
            DataClassification = CustomerContent;
        }
        field(70103; "61-90Days"; Decimal)
        {
            Caption = '61-90 Days';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Parent Location code")
        {
            Clustered = true;
        }
    }

}
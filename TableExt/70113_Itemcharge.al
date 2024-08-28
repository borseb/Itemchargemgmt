tableextension 70113 ItemchargeExt_KPMG extends "Item Charge"
{
    fields
    {
        field(50001; "Vendor No"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Vendor;
        }
        field(50002; "Provision Direct Cost Applied"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
        field(50003; "Provision Item Charge No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(50004; IsProvisionCharge; Boolean)
        {
            DataClassification = ToBeClassified;
        }

    }
}
tableextension 70117 GenPostingSetupExt_KPMG extends "General Posting Setup"
{
    fields
    {
        field(50000; "Provision for Purchase Acc."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50001; "Vendor No"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Vendor;
        }


    }
}
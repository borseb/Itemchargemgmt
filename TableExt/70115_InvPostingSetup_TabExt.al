tableextension 70115 InvPostSetupExt_KPMG extends "Inventory Posting Setup"
{
    fields
    {
        field(50000; "Provision Inventory (Interim)"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50001; "Provision Inventory"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }

    }
}
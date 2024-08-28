tableextension 70116 GenLedgerSetupExt_KPMG extends "General Ledger Setup"
{
    fields
    {
        field(50000; "Provision for Purchase Acc."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }


    }
}
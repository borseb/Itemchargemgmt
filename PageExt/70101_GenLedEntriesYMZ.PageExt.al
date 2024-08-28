pageextension 70101 GLEntriesKPMG extends "General Ledger Entries"
{
    layout
    {
        addafter("Document No.")
        {
            field("Vendor Invoice No KPMG"; Rec."Vendor Invoice No KPMG")
            {
                ApplicationArea = All;
            }
        }
    }
}
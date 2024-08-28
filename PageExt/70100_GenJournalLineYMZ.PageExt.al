pageextension 70100 GenJournalLineKPMG extends "Journal Voucher"
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
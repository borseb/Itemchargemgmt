pageextension 70102 GetPurchRecptLineKPMG extends "Item Charge Assignment (Purch)"
{
    layout
    {
        addafter("Applies-to Doc. No.")
        {
            field(VendorInvoiceNoKPMG; Rec.VendorInvoiceNoKPMG)
            {
                ApplicationArea = All;
            }
            field("Provision Item Charge No."; Rec."Provision Item Charge No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
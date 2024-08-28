pageextension 70107 PurchReceiptLinesYamazen extends "Purch. Receipt Lines"
{
    layout
    {
        addbefore(Type)
        {
            field("Blanket Order No."; Rec."Blanket Order No.")
            {
                ApplicationArea = All;
            }
            field(VendorInvoiceNoYamazen; Rec.VendorInvoiceNoKPMG)
            {
                ApplicationArea = all;
            }
        }
    }
}
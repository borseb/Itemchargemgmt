tableextension 70108 PurchaseReceiptLine_KPMG extends "Purch. Rcpt. Line"
{
    fields
    {
        field(50101; VendorInvoiceNoKPMG; Code[35])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor Invoice No.';
        }
    }
}
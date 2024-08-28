tableextension 70102 PurchaseReceiptLineKPMG extends "Item Charge Assignment (Purch)"
{
    fields
    {
        field(50101; VendorInvoiceNoKPMG; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor Invoice No.';
        }
        field(50102; "Provision Item Charge No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }
    }
}
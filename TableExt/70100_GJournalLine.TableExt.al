tableextension 70129 GenJnLineKPMG extends "Gen. Journal Line"
{
    fields
    {
        field(50101; "Vendor Invoice No KPMG"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor Invoice No.';
            // TableRelation = "Purch. Inv. Header"."Vendor Invoice No.";
            trigger OnLookup()
            var
                PurchInvHeader: Record "Purch. Inv. Header";
            begin
                PurchInvHeader.Reset();
                if Page.RunModal(Page::"Posted Purchase Invoices", PurchInvHeader) = Action::LookupOK then
                    "Vendor Invoice No KPMG" := PurchInvHeader."Vendor Invoice No.";

            end;
        }
        field(70101; "Provisional Inv"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}
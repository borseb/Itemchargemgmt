report 70103 OpenProvisionUpdation
{
    ApplicationArea = All;
    Caption = 'OpenProvisionUpdation';
    UsageCategory = Lists;
    ProcessingOnly = true;
    dataset
    {
        dataitem(Purreceiptline; "Purch. Rcpt. Line")
        {
            RequestFilterFields = "Document No.";
            DataItemTableView = where(Type = const(Item));
            column(ItemNo; "No.")
            {
            }
            column(PostingDate; "Posting Date")
            {
            }

            trigger OnAfterGetRecord()
            var

            begin
                Openpro.Reset();
                Openpro.SetRange("Receipt No.", Purreceiptline."Document No.");

                if Openpro.IsEmpty then begin

                    Openpro.Init();
                    Openpro."Receipt No." := Purreceiptline."Document No.";
                    Openpro."Line No." := Purreceiptline."Line No.";
                    Openpro."BPO No." := Purreceiptline."Blanket Order No.";
                    if PurchReceiptHdr.Get(Purreceiptline."Document No.") then
                        Openpro."PO No." := PurchReceiptHdr."Order No.";
                    Openpro."Item No." := Purreceiptline."No.";
                    Openpro."Item Description" := Purreceiptline.Description;
                    Openpro."Posting Date" := Purreceiptline."Posting Date";
                    Dimn.Reset();
                    Dimn.SetRange("Dimension Code", Purreceiptline."Shortcut Dimension 2 Code");
                    Dimn.SetRange("Dimension Set ID", Purreceiptline."Dimension Set ID");
                    if Dimn.FindFirst() then
                        Openpro.Commodity := Dimn."Dimension Value Code";
                    Openpro.Quantity := Purreceiptline.Quantity;
                    Openpro."Location Code" := Purreceiptline."Location Code";
                    ILE.Reset();
                    ILE.SetRange("Entry Type", ILE."Entry Type"::Purchase);
                    ILE.SetRange("Document Type", ile."Document Type"::"Purchase Receipt");
                    ILE.SetRange("Posting Date", Purreceiptline."Posting Date");
                    ILE.SetRange("Document No.", Purreceiptline."Document No.");
                    if ILE.FindFirst() then
                        Openpro."Item Ledger Entry No" := ILE."Entry No.";
                    Openpro.Insert();
                end;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    var

        PurchLine: Record "Purchase Line";
        Purchhdr: Record "Purchase Header";
        PurchReceiptHdr: Record "Purch. Rcpt. Header";
        Dimn: Record "Dimension Set Entry";
        ILE: Record "Item Ledger Entry";
        Openpro: Record "Open Provision";
}

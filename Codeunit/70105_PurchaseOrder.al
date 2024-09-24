codeunit 70105 POtest
{
    TableNo = 70103;
    trigger OnRun()
    begin

    end;


    var
        Purreceiptline: Record "Purch. Rcpt. Line";
        PurchLine: Record "Purchase Line";
        Purchhdr: Record "Purchase Header";
        PurchReceiptHdr: Record "Purch. Rcpt. Header";
        Dimn: Record "Dimension Set Entry";
        ILE: Record "Item Ledger Entry";
        Openpro: Record "Open Provision";
    /*
        [EventSubscriber(ObjectType::Table, Database::"Purchase Line", OnValidateOverReceiptQuantity, '', false, false)]

        local procedure OnValidateOverReceiptQuantity(var PurchaseLine: Record "Purchase Line"; xPurchaseLine: Record "Purchase Line"; CalledByFieldNo: Integer; var Handled: Boolean)
        var
            OverReceiptMgt: Codeunit "Over-Receipt Mgt.";
            PurchHdr: Record 38;
            OverReceiptCode: Record "Over-Receipt Code";
        begin
            PurchHdr.get(PurchaseLine."Document Type", PurchaseLine."Document No.");
            if PurchaseLine."Document Type" = PurchaseLine."Document Type"::"Blanket Order" then begin
                if not OverReceiptMgt.IsOverReceiptAllowed() then begin
                    PurchaseLine."Over-Receipt Quantity" := 0;
                    PurchaseLine."Over-Receipt Approval Status" := PurchaseLine."Over-Receipt Approval Status"::" ";
                    exit;
                end;
                PurchaseLine.TestField(Type, PurchaseLine.Type::Item);
                PurchaseLine.TestField("No.");
                if PurchaseLine."Over-Receipt Quantity" <> 0 then begin
                    if PurchaseLine."Over-Receipt Code" = '' then
                        PurchaseLine."Over-Receipt Code" := OverReceiptMgt.GetDefaultOverReceiptCode(PurchaseLine);
                    PurchaseLine.TestField("Over-Receipt Code");
                end;
                // if PurchaseLine."Over-Receipt Quantity" <> 0 then
                //     CheckLocationRequireReceive();
                if (PurchaseLine."Over-Receipt Code" <> '') then begin
                    OverReceiptMgt.VerifyOverReceiptQuantity(PurchaseLine, xPurchaseLine);
                    OverReceiptCode.Get(PurchaseLine."Over-Receipt Code");
                    if OverReceiptCode."Required Approval" then
                        PurchaseLine."Over-Receipt Approval Status" := "Over-Receipt Approval Status"::Pending;
                end;
                // SuspendStatusCheck(true);
                PurchaseLine.Validate(Quantity, PurchaseLine.Quantity - xPurchaseLine."Over-Receipt Quantity" + PurchaseLine."Over-Receipt Quantity");
                PurchaseLine.Validate("Direct Unit Cost");
                /* if PurchaseLine."Over-Receipt Quantity" = 0 then begin
                     PurchaseLine."Over-Receipt Approval Status" := "Over-Receipt Approval Status"::" ";
                     OverReceiptMgt.RecallOverReceiptNotification(PurchHdr.RecordId());
                 end else
                     OverReceiptMgt.ShowOverReceiptNotificationFromLine(PurchHdr."No.");  */

    /* commnet by brb   Handled := true;
   end;
end;



[EventSubscriber(ObjectType::Codeunit, Codeunit::"Blanket Purch. Order to Order", OnBeforeInsertPurchOrderLine, '', false, false)]
local procedure OnBeforeInsertPurchOrderLine(var PurchOrderLine: Record "Purchase Line"; PurchOrderHeader: Record "Purchase Header"; var BlanketOrderPurchLine: Record "Purchase Line"; BlanketOrderPurchHeader: Record "Purchase Header")
var
   OverReceiptcode: Record "Over-Receipt Code";
begin
   // Clear(PurchOrderLine."Over-Receipt Quantity");
   if OverReceiptcode.Get(PurchOrderLine."Over-Receipt Code") then
       //  PurchOrderLine.Validate("Over-Receipt Quantity", (PurchOrderLine.Quantity * OverReceiptcode."Over-Receipt Tolerance %") / 100);
       PurchOrderLine."Over-Receipt Quantity" := (PurchOrderLine.Quantity * OverReceiptcode."Over-Receipt Tolerance %") / 100;
   PurchOrderLine."Original PO Qty" := PurchOrderLine.Quantity;
end;

[EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnBeforeInsertReceiptLine, '', false, false)]
local procedure OnBeforeInsertReceiptLine(var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchLine: Record "Purchase Line"; var CostBaseAmount: Decimal; var IsHandled: Boolean);
var
   itemcharge: Record "Item Charge";
begin
   if itemcharge.Get(PurchLine."No.") then begin
       if Itemcharge.IsProvisionCharge then
           if PurchLine."Qty. to Receive" <> 0 then
               Error('Qty to Receive must be blank for Provision Item Charge');
   end;
end;
*/

}
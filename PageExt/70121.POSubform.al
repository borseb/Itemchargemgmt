pageextension 70121 PurchaseOrder_Subform extends "Purchase Order Subform"
{
    layout
    {
        modify("Over-Receipt Code")
        {
            trigger OnAfterValidate()
            var
                OverReceiptcode: Record "Over-Receipt Code";
            begin
                //  if OverReceiptcode.Get(Rec."Over-Receipt Code") then begin
                //     Rec.Validate("Over-Receipt Quantity", (Rec."Original PO Qty" * OverReceiptcode."Over-Receipt Tolerance %") / 100);
                //    Rec.Modify();
                //   end;
            end;
        }
        //  modify(Quantity)
        //   {
        //      Editable = false;
        //  }
        addbefore(Quantity)
        {
            field("Original PO Qty"; Rec."Original PO Qty")
            {
                ApplicationArea = All;
                trigger OnValidate()
                var
                    OverReceiptcode: Record "Over-Receipt Code";
                begin
                    if OverReceiptcode.Get(Rec."Over-Receipt Code") then begin
                        Rec.Validate("Over-Receipt Quantity", (Rec."Original PO Qty" * OverReceiptcode."Over-Receipt Tolerance %") / 100);
                        Rec.Modify();
                    end;
                end;
            }
        }

    }


}

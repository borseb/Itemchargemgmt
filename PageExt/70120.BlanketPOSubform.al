pageextension 70120 BlanketPurchaseOrder_Subform extends "Blanket Purchase Order Subform"
{
    layout
    {
        addbefore(Quantity)
        {
            field("Original Contract Qty"; Rec."Original Contract Qty")
            {
                ApplicationArea = All;
            }
            field("Over-Receipt Code"; Rec."Over-Receipt Code")
            {
                ApplicationArea = All;
                /* trigger OnValidate()
                 var
                     OverReceiptcode: Record "Over-Receipt Code";
                 begin
                     if OverReceiptcode.Get(Rec."Over-Receipt Code") then begin
                         Rec.Validate("Over-Receipt Quantity", (Rec."Original Contract Qty" * OverReceiptcode."Over-Receipt Tolerance %") / 100);
                         Rec.Modify();
                     end;

                 end; */
            }
            field("Over-Receipt Quantity"; Rec."Over-Receipt Quantity")
            {
                ApplicationArea = All;
            }
        }
        modify(Quantity)
        {
            Editable = false;
        }

    }


}

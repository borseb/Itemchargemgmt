codeunit 70104 Itemcharge
{
    //>> BRB 07/11/24
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Charge Assgnt. (Purch.)", 'OnBeforeInsertItemChargeAssgntWithAssignValues', '', false, false)]
    local procedure OnBeforeInsertItemChargeAssgntWithAssignValues(var ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)"; FromItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)")
    var
        Itemcharge: Record "Item Charge";
    begin
        if Itemcharge.Get(FromItemChargeAssgntPurch."Item Charge No.") then
            ItemChargeAssgntPurch."Provision Item Charge No." := Itemcharge."Provision Item Charge No.";
    end;
    //<< BRB 07/11/24
}

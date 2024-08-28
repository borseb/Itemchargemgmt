codeunit 70100 ProcessLogicKPMG
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure OnBeforeOnRun_Cust(var SalesHeader: Record "Sales Header"; SalesShptHdrNo: Code[20]; PreviewMode: Boolean)
    var
        Location: Record Location;
        SlabRatesOfPort: Record SlabRateKPMG;
        WarehouseCharges: Record WarehouseCharges;
        SalesShipmentLines: Record "Sales Shipment Line";
        TotalQuantity: Decimal;
        TotalDays: Integer;
        TotalAmount: Decimal;
        TotalMonths: Decimal;
        DebitNoteWS: Record DebitNoteWorksheetKPMG;
        SalesLineQry: Query SalesLine;
        ItemCat: Record "Item Category";
        Days_030: Decimal;
        Days_3160: Decimal;
        Days_6190: Decimal;

    begin
        if not PreviewMode then
            if SalesShptHdrNo <> '' then begin
                if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
                    if Location.Get(SalesHeader."Location Code") then
                        if Location."Location Type KPMG" = Location."Location Type KPMG"::Port then begin
                            Clear(SalesShipmentLines);
                            Clear(TotalQuantity);
                            SalesShipmentLines.SetRange("Document No.", SalesShptHdrNo);
                            if SalesShipmentLines.FindSet() then
                                repeat
                                    TotalQuantity := 0;
                                    TotalQuantity := SalesShipmentLines.Quantity;
                                    TotalDays := Abs(SalesHeader."Posting Date" - SalesHeader."Promised Delivery Date");
                                    if TotalDays >= 10 then
                                        if TotalDays <> 0 then
                                            if TotalQuantity <> 0 then begin
                                                if (TotalDays >= 0) and (TotalDays <= 30) then begin
                                                    Clear(SlabRatesOfPort);
                                                    Clear(TotalAmount);
                                                    Clear(Days_030);
                                                    Clear(Days_3160);
                                                    Clear(Days_6190);
                                                    SlabRatesOfPort.SetRange("Parent Location code", Location.Code);
                                                    if SlabRatesOfPort.FindFirst() then begin
                                                        TotalAmount := SlabRatesOfPort."0-30Days" * TotalQuantity;
                                                        Days_030 := SlabRatesOfPort."0-30Days";
                                                        Days_3160 := SlabRatesOfPort."31-60Days";
                                                        Days_6190 := SlabRatesOfPort."61-90Days";
                                                    end;


                                                end;
                                                if (TotalDays >= 31) and (TotalDays <= 60) then begin
                                                    Clear(SlabRatesOfPort);
                                                    Clear(TotalAmount);
                                                    SlabRatesOfPort.SetRange("Parent Location code", Location.Code);
                                                    if SlabRatesOfPort.FindFirst() then begin
                                                        TotalAmount := SlabRatesOfPort."0-30Days" * TotalQuantity + SlabRatesOfPort."31-60Days" * TotalQuantity;
                                                        Days_030 := SlabRatesOfPort."0-30Days";
                                                        Days_3160 := SlabRatesOfPort."31-60Days";
                                                        Days_6190 := SlabRatesOfPort."61-90Days";
                                                    end;


                                                end;
                                                if (TotalDays >= 61) and (TotalDays <= 90) then begin
                                                    Clear(SlabRatesOfPort);
                                                    Clear(TotalAmount);
                                                    SlabRatesOfPort.SetRange("Parent Location code", Location.Code);
                                                    if SlabRatesOfPort.FindFirst() then begin
                                                        TotalAmount := SlabRatesOfPort."0-30Days" * TotalQuantity + SlabRatesOfPort."31-60Days" * TotalQuantity + SlabRatesOfPort."61-90Days" * TotalQuantity;
                                                        Days_030 := SlabRatesOfPort."0-30Days";
                                                        Days_3160 := SlabRatesOfPort."31-60Days";
                                                        Days_6190 := SlabRatesOfPort."61-90Days";
                                                    end;


                                                end;
                                                Clear(DebitNoteWS);
                                                DebitNoteWS.Init();
                                                DebitNoteWS."Sales Order No." := SalesHeader."No.";
                                                DebitNoteWS."Sales Shipment No." := SalesShptHdrNo;
                                                DebitNoteWS."Customer No." := SalesHeader."Sell-to Customer No.";
                                                DebitNoteWS."Customer Name" := SalesHeader."Sell-to Customer Name";
                                                DebitNoteWS."Location Code" := SalesHeader."Location Code";
                                                DebitNoteWS."Location Type" := Location."Location Type KPMG";
                                                DebitNoteWS."Posting Date" := SalesHeader."Posting Date";
                                                DebitNoteWS."Item Category Code" := SalesShipmentLines."Item Category Code";
                                                DebitNoteWS."0-30Days" := Days_030;
                                                DebitNoteWS."31-60Days" := Days_3160;
                                                DebitNoteWS."61-90Days" := Days_6190;
                                                DebitNoteWS.Status := DebitNoteWS.Status::Pending;
                                                DebitNoteWS.Quantity := TotalQuantity;
                                                DebitNoteWS."Promised Delivery Date" := SalesHeader."Promised Delivery Date";
                                                DebitNoteWS."Total Days" := TotalDays;
                                                DebitNoteWS."Total Charges" := TotalAmount;
                                                DebitNoteWS."Final Charges" := TotalAmount;
                                                DebitNoteWS.Insert();

                                            end;
                                until SalesShipmentLines.Next() = 0;


                        end
                        else begin
                            Clear(SalesShipmentLines);
                            Clear(TotalAmount);
                            Clear(TotalQuantity);
                            Clear(TotalDays);
                            TotalDays := Abs(SalesHeader."Posting Date" - SalesHeader."Promised Delivery Date");
                            Clear(TotalMonths);
                            TotalMonths := Round(TotalDays / 30, 1, '>');
                            if TotalDays >= 10 then
                                if TotalMonths <> 0 then begin
                                    Clear(TotalQuantity);
                                    ItemCat.Reset();
                                    ItemCat.SetFilter("Parent Category", '%1', '');
                                    if ItemCat.FindSet() then
                                        repeat
                                            TotalQuantity := 0;
                                            SalesShipmentLines.SetRange("Document No.", SalesShptHdrNo);
                                            SalesShipmentLines.SetRange("Item Category Code", ItemCat.Code);
                                            if SalesShipmentLines.FindSet() then
                                                repeat
                                                    TotalQuantity += SalesShipmentLines.Quantity;
                                                until SalesShipmentLines.Next() = 0;

                                            if TotalQuantity <> 0 then begin
                                                Clear(DebitNoteWS);
                                                DebitNoteWS.Init();
                                                DebitNoteWS."Sales Order No." := SalesHeader."No.";
                                                DebitNoteWS."Sales Shipment No." := SalesShptHdrNo;
                                                DebitNoteWS."Customer No." := SalesHeader."Sell-to Customer No.";
                                                DebitNoteWS."Customer Name" := SalesHeader."Sell-to Customer Name";
                                                DebitNoteWS."Location Code" := SalesHeader."Location Code";
                                                DebitNoteWS."Location Type" := Location."Location Type KPMG";
                                                DebitNoteWS."Posting Date" := SalesHeader."Posting Date";
                                                DebitNoteWS.Status := DebitNoteWS.Status::Pending;
                                                DebitNoteWS."Promised Delivery Date" := SalesHeader."Promised Delivery Date";
                                                DebitNoteWS."Total Months" := TotalMonths;
                                                DebitNoteWS."Total Days" := TotalDays;
                                                DebitNoteWS.Quantity := TotalQuantity;
                                                DebitNoteWS."Item Category Code" := ItemCat.Code;
                                                Clear(TotalAmount);
                                                Clear(WarehouseCharges);
                                                WarehouseCharges.SetRange("Parent Location code", SalesHeader."Location Code");
                                                WarehouseCharges.SetRange("Item Category Code", ItemCat.Code);
                                                if WarehouseCharges.FindFirst() then begin
                                                    DebitNoteWS."Total Charges" := WarehouseCharges."Charge per month" * TotalMonths * TotalQuantity;
                                                    DebitNoteWS."Final Charges" := WarehouseCharges."Charge per month" * TotalMonths * TotalQuantity;
                                                    DebitNoteWS."Charge per month" := WarehouseCharges."Charge per month";
                                                end;
                                                if DebitNoteWS."Final Charges" <> 0 then
                                                    DebitNoteWS.Insert();
                                            end;
                                        until ItemCat.Next() = 0;
                                end;
                        end;
                end;
            end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnInsertReceiptLineOnAfterInitPurchRcptLine', '', false, false)]
    local procedure OnInsertReceiptLineOnAfterInitPurchRcptLine(PurchLine: Record "Purchase Line"; var PurchRcptLine: Record "Purch. Rcpt. Line")
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        PurchaseHeader.SetFilter("No.", PurchLine."Document No.");
        if PurchaseHeader.FindFirst() then begin
            PurchRcptLine.VendorInvoiceNoKPMG := PurchaseHeader."Vendor Invoice No.";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertGlobalGLEntry', '', true, true)]
    local procedure OnBeforeInsertGlobalGLEntry(GenJournalLine: Record "Gen. Journal Line"; var GlobalGLEntry: Record "G/L Entry")
    var
        PurchaseInvHeader: Record "Purch. Inv. Header";
    begin
        GlobalGLEntry."Vendor Invoice No KPMG" := GenJournalLine."Vendor Invoice No KPMG";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostPurchaseDoc', '', true, true)]
    local procedure OnBeforeCreateRcptChargeAssgnt(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean)
    var
        PurchRcptLines: Record "Purch. Rcpt. Line";
        ItemChargeAssgnPurch: Query ItemChargeAssgnPurchKPMG;
        ValueEntries: Record "Value Entry";
        ILE: Record "Item Ledger Entry";
        ItemChargeAssignPurch: Record "Item Charge Assignment (Purch)";
        ItemChargeAssignPurchForCrMemo: Record "Item Charge Assignment (Purch)";
        GenJournalLine: Record "Gen. Journal Line";
        GLEntries: Record "G/L Entry";
        TotalAmt: Decimal;
        GenJournalBatch: Record "Gen. Journal Batch";
        NoSeriesMgm: Codeunit NoSeriesManagement;
        VenInvNoKPMG: Text;
        Preview: Boolean;
        PurchHeader_Rec: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        PurchAndPayableSetup: Record "Purchases & Payables Setup";
        CrMemoNo: Code[20];
        PurchLineSubForm: Page "Purch. Cr. Memo Subform";
        VenCrMemoNo: Code[100];
        Itemcharge: Record "Item Charge";
        i: Integer;
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        VenCrMemo2: Code[20];
        Vend: Record Vendor;
        ChargeItemAmt: Decimal;
        ItemChargeAssign: Codeunit "Item Charge Assgnt. (Purch.)";
        currencyExc: Record "Currency Exchange Rate";
    begin
        if not PreviewMode then begin
            if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice then
                if (PurchaseHeader."Charge Item Type KPMG" = PurchaseHeader."Charge Item Type KPMG"::Actual) then begin
                    Clear(ILE);
                    ChargeItemAmt := 0;
                    Clear(CrMemoNo);
                    Clear(PurchAndPayableSetup);
                    ItemChargeAssignPurch.SetCurrentKey("Applies-to Doc. Type", "Applies-to Doc. No.", "Applies-to Doc. Line No.");
                    ItemChargeAssignPurch.SetRange("Document No.", PurchaseHeader."No.");
                    if ItemChargeAssignPurch.FindSet() then
                        repeat
                            // Clear(PurchRcptLines);
                            // PurchRcptLines.SetRange("Document No.", ItemChargeAssignPurch."Applies-to Doc. No.");
                            // PurchRcptLines.SetRange("Line No.", ItemChargeAssignPurch."Applies-to Doc. Line No.");
                            // if PurchRcptLines.FindFirst() then;
                            Clear(ILE);
                            ILE.SetRange("Document No.", ItemChargeAssignPurch."Applies-to Doc. No.");
                            ILE.SetRange("Document Line No.", ItemChargeAssignPurch."Applies-to Doc. Line No.");
                            ILE.SetRange("Item No.", ItemChargeAssignPurch."Item No.");
                            TotalAmt := 0;
                            if ILE.FindFirst() then begin
                                Clear(ValueEntries);
                                ValueEntries.SetRange("Item Ledger Entry No.", ILE."Entry No.");
                                ValueEntries.SetFilter("Item Charge No.", '<>%1', '');
                                ValueEntries.SetRange("Item Charge No.", ItemChargeAssignPurch."Provision Item Charge No.");
                                if ValueEntries.FindSet() then
                                    repeat
                                        ValueEntries.CalcFields("Charge(Item) Type KPMG");
                                        ValueEntries.CalcFields("Charge(Item) Type KPMG CR");
                                        if ValueEntries."Charge(Item) Type KPMG" = ValueEntries."Charge(Item) Type KPMG"::Provisional then
                                            TotalAmt += ValueEntries."Cost Posted to G/L";
                                        if ValueEntries."Charge(Item) Type KPMG CR" = ValueEntries."Charge(Item) Type KPMG CR"::Provisional then
                                            TotalAmt += ValueEntries."Cost Posted to G/L";

                                    until ValueEntries.Next() = 0;
                            end;

                            if ItemChargeAssignPurch."Amount to Assign" > TotalAmt then
                                TotalAmt := TotalAmt;
                            if ItemChargeAssignPurch."Amount to Assign" <= TotalAmt then
                                TotalAmt := ItemChargeAssignPurch."Amount to Assign";

                            //>> 07/11/2024 BRB


                            if TotalAmt <> 0 then begin

                                if VenCrMemo2 = '' then begin
                                    VenCrMemo2 := ItemChargeAssignPurch."Applies-to Doc. No.";
                                    VenCrMemoNo := ItemChargeAssignPurch."Applies-to Doc. No.";
                                end
                                else begin
                                    if VenCrMemo2 = ItemChargeAssignPurch."Applies-to Doc. No." then begin
                                        i += 1;
                                        VenCrMemoNo := ItemChargeAssignPurch."Applies-to Doc. No." + Format(i);
                                    end
                                    else begin
                                        VenCrMemoNo := ItemChargeAssignPurch."Applies-to Doc. No.";
                                        VenCrMemo2 := ItemChargeAssignPurch."Applies-to Doc. No.";
                                    end;
                                end;
                                //>> BRB_KPMG_20012024
                                PurchCrMemoHeader.Reset();
                                PurchCrMemoHeader.SetRange("Vendor Cr. Memo No.", ItemChargeAssignPurch."Applies-to Doc. No.");
                                if PurchCrMemoHeader.FindFirst then begin
                                    i += 1;
                                    VenCrMemoNo := ItemChargeAssignPurch."Applies-to Doc. No." + Format(i);
                                end;
                                if Itemcharge.Get(ItemChargeAssignPurch."Provision Item Charge No.") then;

                                //>> BRB_KPMG_20012024
                                PurchAndPayableSetup.Get();
                                // PurchAndPayableSetup.TestField("Provisional Vendor No.");
                                //  PurchAndPayableSetup.TestField("Location Code KPMG");
                                Clear(PurchHeader_Rec);
                                PurchHeader_Rec.Init();
                                CrMemoNo := NoSeriesMgm.GetNextNo(PurchAndPayableSetup."Credit Memo Nos.", WorkDate(), true);
                                PurchHeader_Rec."No." := CrMemoNo;
                                PurchHeader_Rec."Document Type" := PurchaseHeader."Document Type"::"Credit Memo";
                                //PurchHeader_Rec.Validate("Buy-from Vendor No.", PurchAndPayableSetup."Provisional Vendor No.");
                                PurchHeader_Rec.Validate("Buy-from Vendor No.", Itemcharge."Vendor No");
                                PurchHeader_Rec.Validate("Posting Date", PurchaseHeader."Posting Date");
                                PurchHeader_Rec."Vendor Cr. Memo No." := VenCrMemoNo;
                                PurchHeader_Rec.Validate("Location Code", PurchAndPayableSetup."Location Code KPMG");
                                // PurchHeader_Rec."Purchaser Code" := 'NA';
                                PurchHeader_Rec."Charge Item Type KPMG" := PurchaseHeader."Charge Item Type KPMG"::Provisional;
                                PurchHeader_Rec.Insert(true);
                                Clear(PurchLine);
                                PurchLine.Init();
                                PurchLine."Document Type" := PurchLine."Document Type"::"Credit Memo";
                                PurchLine."Document No." := CrMemoNo;
                                PurchLine."Line No." := 10000;
                                PurchLine.Type := PurchLine.Type::"Charge (Item)";
                                //PurchLine.Validate("No.", 'FREIGHT');
                                PurchLine.Validate("No.", ItemChargeAssignPurch."Provision Item Charge No.");   //BRB change due to Swapnil
                                PurchLine.Validate(Quantity, 1);
                                if Vend.get(PurchHeader_Rec."Buy-from Vendor No.") then;
                                currencyExc.Reset();
                                currencyExc.SetRange("Currency Code", vend."Currency Code");
                                currencyExc.SetFilter("Starting Date", '<=%1', Today);
                                if currencyExc.FindLast() then
                                    TotalAmt := TotalAmt / currencyExc."Relational Exch. Rate Amount";
                                PurchLine.Validate("Direct Unit Cost", TotalAmt);
                                PurchLine.Insert(true);

                                Clear(ItemChargeAssignPurchForCrMemo);
                                ItemChargeAssignPurchForCrMemo.Init();
                                ItemChargeAssignPurchForCrMemo."Document Type" := ItemChargeAssignPurchForCrMemo."Document Type"::"Credit Memo";
                                ItemChargeAssignPurchForCrMemo."Document No." := CrMemoNo;
                                ItemChargeAssignPurchForCrMemo.Validate("Document Line No.", 10000);
                                ItemChargeAssignPurchForCrMemo."Line No." := 10000;
                                ItemChargeAssignPurchForCrMemo."Item Charge No." := ItemChargeAssignPurch."Provision Item Charge No.";//'FREIGHT'  BRB
                                ItemChargeAssignPurchForCrMemo.Validate("Applies-to Doc. Type", ItemChargeAssignPurchForCrMemo."Applies-to Doc. Type"::Receipt);
                                ItemChargeAssignPurchForCrMemo.Validate("Applies-to Doc. No.", ItemChargeAssignPurch."Applies-to Doc. No.");
                                ItemChargeAssignPurchForCrMemo."Applies-to Doc. Line No." := ItemChargeAssignPurch."Applies-to Doc. Line No.";
                                // ItemChargeAssignPurchForCrMemo.Validate("Applies-to Doc. Line No.", ItemChargeAssignPurch."Applies-to Doc. Line No.");
                                ItemChargeAssignPurchForCrMemo."Item No." := ItemChargeAssignPurch."Item No.";
                                ItemChargeAssignPurchForCrMemo.Validate("Qty. to Assign", 1);
                                ItemChargeAssignPurchForCrMemo.Description := ItemChargeAssignPurch.Description;
                                ItemChargeAssignPurchForCrMemo.Validate("Qty. to Handle", 1);
                                ItemChargeAssignPurchForCrMemo."Unit Cost" := ItemChargeAssignPurch."Unit Cost";
                                if ItemChargeAssignPurch."Amount to Assign" > TotalAmt then begin
                                    ItemChargeAssignPurchForCrMemo."Amount to Assign" := TotalAmt;
                                    ItemChargeAssignPurchForCrMemo."Amount to Handle" := TotalAmt;
                                end;
                                if ItemChargeAssignPurch."Amount to Assign" <= TotalAmt then begin
                                    ItemChargeAssignPurchForCrMemo."Amount to Assign" := ItemChargeAssignPurch."Amount to Assign";
                                    ItemChargeAssignPurchForCrMemo."Amount to Handle" := ItemChargeAssignPurch."Amount to Handle";
                                end;//comment by BRB
                                ItemChargeAssignPurchForCrMemo.Insert();

                                Clear(PurchLine);
                                PurchLine.SetRange("Document No.", CrMemoNo);
                                PurchLine.SetRange("Document Type", PurchLine."Document Type"::"Credit Memo");
                                if PurchLine.FindFirst() then begin
                                    PurchLine.Validate("Qty. to Assign", 1);
                                    PurchLine.Modify(true);
                                    PurchHeader_Rec.SetRange("No.", CrMemoNo);
                                    if PurchHeader_Rec.FindFirst() then
                                        CODEUNIT.Run(CODEUNIT::"Purch.-Post", PurchHeader_Rec);
                                end;
                            end;
                        until ItemChargeAssignPurch.Next() = 0;

                end;
        end;

        // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnRunOnAfterPostInvoice', '', true, true)]
        // local procedure OnBeforeCreateRcptChargeAssgnt(var PurchaseHeader: Record "Purchase Header"; var PreviewMode: Boolean)
        // var
        //     PurchRcptLines: Record "Purch. Rcpt. Line";
        //     ItemChargeAssgnPurch: Query ItemChargeAssgnPurchKPMG;
        //     GenJournalLine: Record "Gen. Journal Line";
        //     GLEntries: Record "G/L Entry";
        //     TotalAmt: Decimal;
        //     GenJournalBatch: Record "Gen. Journal Batch";
        //     NoSeriesMgm: Codeunit NoSeriesManagement;
        //     VenInvNoKPMG: Text;
        //     Preview: Boolean;
        //     PurchzCrMemoHeader:Record "Purchase Header";
        //     PurchLine:Record "Purchase Line";
        // begin
        //     if not PreviewMode then begin
        //         Clear(GenJournalBatch);
        //         GenJournalBatch.SetRange(Name, 'DEFAULT');
        //         GenJournalBatch.SetRange("Journal Template Name", 'JOURNAL V');
        //         if GenJournalBatch.FindFirst() then;
        //         Clear(PurchRcptLines);
        //         Clear(ItemChargeAssgnPurch);
        //         Clear(GLEntries);

        //         ItemChargeAssgnPurch.SetRange(ItemChargeAssgnPurch.Applies_to_Doc__Type, ItemChargeAssgnPurch.Applies_to_Doc__Type::Receipt);
        //         ItemChargeAssgnPurch.SetRange(ItemChargeAssgnPurch.Document_No_, PurchaseHeader."No.");
        //         ItemChargeAssgnPurch.Open();
        //         while ItemChargeAssgnPurch.Read() do begin
        //             PurchRcptLines.SetRange("Document No.", ItemChargeAssgnPurch.Applies_to_Doc__No_);
        //             if PurchRcptLines.FindFirst() then begin
        //                 GLEntries.SetRange("Vendor Invoice No KPMG", PurchRcptLines.VendorInvoiceNoYamazen);
        //                 GLEntries.SetRange("G/L Account No.", '21414');

        //                 TotalAmt := 0;
        //                 if GLEntries.FindSet() then
        //                     repeat
        //                         TotalAmt += GLEntries.Amount;
        //                     until GLEntries.Next() = 0;
        //                 if TotalAmt > 0 then begin
        //                     // if VenInvNoKPMG = '' then
        //                     VenInvNoKPMG := PurchRcptLines.VendorInvoiceNoYamazen;
        //                     // else
        //                     //     VenInvNoKPMG := VenInvNoKPMG + '|' + PurchRcptLines.VendorInvoiceNoYamazen;

        //                     Clear(GenJournalLine);
        //                     GenJournalLine.SetRange("Journal Alloc. Template Name", 'JOURNAL V');
        //                     GenJournalLine.SetRange("Journal Batch Name", GenJournalBatch.Name);
        //                     GenJournalLine.DeleteAll(true);
        //                     Clear(GenJournalLine);
        //                     GenJournalLine.Init();
        //                     GenJournalLine."Journal Batch Name" := GenJournalBatch.Name;
        //                     GenJournalLine."Journal Template Name" := 'JOURNAL V';
        //                     GenJournalLine."Posting Date" := WorkDate();
        //                     GenJournalLine."Document No." := NoSeriesMgm.GetNextNo(GenJournalBatch."No. Series", WorkDate(), true);
        //                     GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
        //                     GenJournalLine.Validate("Account No.", '61000');
        //                     GenJournalLine.Validate(Amount, TotalAmt);
        //                     GenJournalLine."Salespers./Purch. Code" := GLEntries."Shortcut Dimension 3 Code";
        //                     GenJournalLine."Vendor Invoice No KPMG" := GLEntries."Vendor Invoice No KPMG";
        //                     GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
        //                     GenJournalLine.Validate("Bal. Account No.", '21414');
        //                     GenJournalLine."Shortcut Dimension 1 Code" := GLEntries."Global Dimension 1 Code";
        //                     GenJournalLine."Shortcut Dimension 2 Code" := GLEntries."Global Dimension 2 Code";
        //                     GenJournalLine.Insert();

        //                     Clear(GenJournalLine);
        //                     GenJournalLine.SetFilter("Vendor Invoice No KPMG", VenInvNoKPMG);
        //                     GenJournalLine.SetRange("Journal Alloc. Template Name", 'JOURNAL V');
        //                     GenJournalLine.SetRange("Journal Batch Name", GenJournalBatch.Name);
        //                     if GenJournalLine.FindFirst() then begin
        //                         Codeunit.Run(Codeunit::"Gen. Jnl.-Post", GenJournalLine);
        //                     end;



        //                 end;

        //             end;
        //         end;
        //         // ItemChargeAssgnPurch.Close();
        //         // if not PreviewMode then begin


        //         // end;
        //     end;


    end;


}
codeunit 70102 ItemchargeInvoiceKPMG
{
    Permissions = tabledata 122 = rimd, tabledata 123 = rimd, tabledata 121 = rimd;

    //[EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchRcptLineInsert', '', true, true)]
    //local procedure OnAfterPurchRcptLineInsert(PurchaseLine: Record "Purchase Line"; var PurchRcptLine: Record "Purch. Rcpt. Line"; ItemLedgShptEntryNo: Integer; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSupressed: Boolean; PurchInvHeader: Record "Purch. Inv. Header"; var TempTrackingSpecification: Record "Tracking Specification" temporary; PurchRcptHeader: Record "Purch. Rcpt. Header"; TempWhseRcptHeader: Record "Warehouse Receipt Header"; xPurchLine: Record "Purchase Line"; var TempPurchLineGlobal: Record "Purchase Line" temporary)
    //begin
    /// BRB CreateProvisionalEntry(PurchRcptLine, PurchaseLine);
    //end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchInvHeaderInsert', '', true, true)]
    local procedure OnAfterPurchInvHeaderInsert(var PurchInvHeader: Record "Purch. Inv. Header"; var PurchHeader: Record "Purchase Header"; PreviewMode: Boolean)
    var
        vendor: Record 23;
        itemcharge: Record "Item Charge";
        PurchLine: Record "Purchase Line";
        SourceCodeSetup: Record "Source Code Setup";

    begin
        PurchLine.Reset();

    end;
    // Create Purchase Invoice
    //[EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchaseDoc', '', true, true)]

    //local procedure OnBeforePurchRcptLineInsert(var PurchRcptLine: Record "Purch. Rcpt. Line"; var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchLine: Record "Purchase Line"; CommitIsSupressed: Boolean; PostedWhseRcptLine: Record "Posted Whse. Receipt Line"; var IsHandled: Boolean)
    //local procedure OnAfterPurchRcptLineInsert(PurchaseLine: Record "Purchase Line"; var PurchRcptLine: Record "Purch. Rcpt. Line"; ItemLedgShptEntryNo: Integer; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSupressed: Boolean; PurchInvHeader: Record "Purch. Inv. Header"; var TempTrackingSpecification: Record "Tracking Specification" temporary; PurchRcptHeader: Record "Purch. Rcpt. Header"; TempWhseRcptHeader: Record "Warehouse Receipt Header"; xPurchLine: Record "Purchase Line"; var TempPurchLineGlobal: Record "Purchase Line" temporary)
    // local procedure OnAfterProcessPurchLines(var PurchHeader: Record "Purchase Header"; var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchInvHeader: Record "Purch. Inv. Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var ReturnShipmentHeader: Record "Return Shipment Header"; WhseShip: Boolean; WhseReceive: Boolean; var PurchLinesProcessed: Boolean; CommitIsSuppressed: Boolean; EverythingInvoiced: Boolean)
    procedure OnAfterPostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PurchRcpHdrNo: Code[20]; RetShptHdrNo: Code[20]; PurchInvHdrNo: Code[20]; PurchCrMemoHdrNo: Code[20]; CommitIsSupressed: Boolean)
    var
        PurchHdr: Record 38;
        DocNo: Code[20];
        //PurchaseHeader: Record 38;
        Itemcharge: Record "Item Charge";
        NoSeriesMgm: Codeunit NoSeriesManagement;
        PurchLine: Record 39;
        PurchaseLine: Record 121;
        PurchRcptHeader: Record 120;
        ItemChargeAssignPurchInv: Record 5805;
        ItemChargeAssignPurch: Record 5805;
        GenPostSetup: Record "General Posting Setup";
        LocVendor: Record 23;
    begin
        if PurchaseHeader."Document Type" <> PurchaseHeader."Document Type"::Order then
            exit;
        if PurchRcptHeader.Get(PurchRcpHdrNo) then;
        //if PurchaseHeader.Get(PurchaseLine."Document Type", PurchaseLine."Document No.") then;
        PurchaseLine.Reset();
        PurchaseLine.SetCurrentKey("Document No.", Type);
        ///PurchOrderLine.SetRange("Document Type", PurchOrderLine."Document Type"::Order);
        PurchaseLine.SetRange("Document No.", PurchRcptHeader."No.");
        PurchaseLine.SetRange(Type, PurchaseLine.Type::"Charge (Item)");
        //PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        if PurchaseLine.FindSet() then
            repeat
                //if PurchaseLine.Type <> PurchaseLine.Type::"Charge (Item)" then
                //  exit;
                itemcharge.Get(PurchaseLine."No.");
                if LocVendor.Get(PurchaseHeader."Buy-from Vendor No.") then;
                /*
                GenPostSetup.RESET;
                GenPostSetup.SETRANGE(GenPostSetup."Gen. Bus. Posting Group", LocVendor."Gen. Bus. Posting Group");
                GenPostSetup.SETRANGE(GenPostSetup."Gen. Prod. Posting Group", itemcharge."Gen. Prod. Posting Group");
                IF GenPostSetup.FINDFIRST THEN BEGIN
                    // GenPostSetup.TESTFIELD(GenPostSetup."Provision For Purchase Acc.");
                    GenPostSetup.TestField("Vendor No");
                END;
                */


                if Itemcharge."Vendor No" = '' then
                    exit;

                PurchHdr.Init();
                //PurchHdr.TransferFields(PurchaseHeader);
                DocNo := NoSeriesMgm.GetNextNo('P-INV', WorkDate(), true);
                PurchHdr."No." := DocNo;
                PurchHdr."Document Type" := PurchHdr."Document Type"::Invoice;
                PurchHdr."No." := DocNo;
                PurchHdr.Validate(Status, PurchHdr.Status::Open);
                PurchHdr.Validate("Buy-from Vendor No.", Itemcharge."Vendor No");
                PurchHdr.Validate("Posting Date", PurchRcptHeader."Posting Date");
                PurchHdr.Validate("Vendor Invoice No.", PurchaseHeader."Vendor Invoice No.");
                PurchHdr.Validate("Document Date", PurchaseHeader."Document Date");
                PurchHdr.Validate("Payment Terms Code", PurchaseHeader."Payment Terms Code");
                PurchHdr.Validate("Location Code", PurchaseHeader."Location Code");
                PurchHdr.Validate("Order Date", PurchaseHeader."Order Date");
                PurchHdr.Validate("Provisional Inv", true);
                PurchHdr.Validate("Currency Code", PurchaseHeader."Currency Code");
                PurchHdr.Insert();

                //PurchHdr.Modify();

                PurchLine.Init();
                PurchLine."Document Type" := PurchLine."Document Type"::Invoice;
                PurchLine."Document No." := DocNo;
                PurchLine."Line No." := 10000;
                PurchLine.Type := PurchLine.Type::"Charge (Item)";
                PurchLine.Validate("No.", PurchaseLine."No.");
                PurchLine.Validate(Quantity, PurchaseLine.Quantity);
                PurchLine.Validate("Qty. to Invoice", PurchaseLine.Quantity);
                PurchLine.Validate("Direct Unit Cost", PurchaseLine."Direct Unit Cost");
                PurchLine.Insert(true);

                // PurchInvLine.Validate("Qty. to Receive", PurchLine."Qty. to Receive");
                // PurchInvLine.Validate("Qty. to Invoice", PurchLine."Qty. to Invoice");
                // PurchInvLine.Validate("Qty. to Assign", PurchLine."Qty. to Assign");
                // // PurchLine.Validate("Direct Unit Cost", TotalAmt);

                //Item charge
                //ItemChargeAssignPurch.SetCurrentKey("Applies-to Doc. Type", "Applies-to Doc. No.", "Applies-to Doc. Line No.");
                //ItemChargeAssignPurch.SetRange("Document No.", PurchaseHeader."No.");
                //if ItemChargeAssignPurch.FindSet() then begin
                Clear(ItemChargeAssignPurchInv);
                ItemChargeAssignPurchInv.Init();
                ItemChargeAssignPurchInv."Document Type" := ItemChargeAssignPurchInv."Document Type"::Invoice;
                ItemChargeAssignPurchInv."Document No." := DocNo;
                //ItemChargeAssignPurchInv.Validate("Document Line No.", 10000);
                ItemChargeAssignPurchInv."Document Line No." := PurchLine."Line No.";
                ItemChargeAssignPurchInv."Line No." := 10000;
                ItemChargeAssignPurchInv."Item Charge No." := Itemcharge."No.";
                ItemChargeAssignPurchInv.Validate("Applies-to Doc. Type", ItemChargeAssignPurchInv."Applies-to Doc. Type"::Receipt);
                //ItemChargeAssignPurchInv.Validate("Applies-to Doc. No.",PurchRcpHdrNo); //ItemChargeAssignPurch."Applies-to Doc. No.");
                ItemChargeAssignPurchInv.Validate("Applies-to Doc. No.", PurchRcptHeader."No.");
                ItemChargeAssignPurchInv."Applies-to Doc. Line No." := ItemChargeAssignPurch."Applies-to Doc. Line No.";
                // ItemChargeAssignPurchInv.Validate("Applies-to Doc. Line No.", ItemChargeAssignPurch."Applies-to Doc. Line No.");
                ItemChargeAssignPurchInv."Item No." := ItemChargeAssignPurch."Item No.";
                ItemChargeAssignPurchInv.Validate("Qty. to Assign", ItemChargeAssignPurch."Qty. to Assign");
                ItemChargeAssignPurchInv.Description := ItemChargeAssignPurch.Description;
                ItemChargeAssignPurchInv.Validate("Qty. to Handle", ItemChargeAssignPurch."Qty. to Handle");
                ItemChargeAssignPurchInv."Unit Cost" := ItemChargeAssignPurch."Unit Cost";
                //if ItemChargeAssignPurch."Amount to Assign" > TotalAmt then begin
                ItemChargeAssignPurchInv."Amount to Assign" := ItemChargeAssignPurch."Amount to Assign";
                ItemChargeAssignPurchInv."Amount to Handle" := ItemChargeAssignPurch."Amount to Handle";
                //end;
                ItemChargeAssignPurchInv.Insert();

                PurchHdr.SetRange("No.", DocNo);
                if PurchHdr.FindFirst() then
                    CODEUNIT.Run(CODEUNIT::"Purch.-Post", PurchHdr);
            //end;
            until PurchaseLine.Next = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromPurchHeader', '', true, true)]
    local procedure OnAfterCopyGenJnlLineFromPurchHeader(PurchaseHeader: Record "Purchase Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."Provisional Inv" := PurchaseHeader."Provisional Inv";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitGLEntry', '', true, true)]
    local procedure OnAfterInitGLEntry(var GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line"; Amount: Decimal; AddCurrAmount: Decimal; UseAddCurrAmount: Boolean; var CurrencyFactor: Decimal; var GLRegister: Record "G/L Register")
    begin
        GLEntry."Provisional Inv" := GenJournalLine."Provisional Inv";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeInsertReceiptHeader', '', true, true)]
    ///local procedure OnCheckAndUpdateOnAfterSetPostingFlags(var PurchHeader: Record "Purchase Header"; var TempPurchLineGlobal: Record "Purchase Line" temporary);
    local procedure OnBeforeInsertReceiptHeader(var PurchHeader: Record "Purchase Header"; var PurchRcptHeader: Record "Purch. Rcpt. Header"; var IsHandled: Boolean; CommitIsSuppressed: Boolean)
    var
        PurchLine: Record 39;
        itemcharge: Record "Item Charge";
    begin
        PurchLine.Reset();
        PurchLine.SetRange(PurchLine."Document Type", PurchLine."Document Type"::Invoice);
        PurchLine.SetRange("Document No.", PurchHeader."No.");
        PurchLine.SetRange(Type, PurchLine.Type::"Charge (Item)");
        if PurchLine.FindSet then
            repeat
                if itemcharge.Get(PurchLine."No.") then;
                if itemcharge."Vendor No" <> '' then
                    IsHandled := true;
            until PurchLine.Next = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchRcptLineInsert', '', true, true)]

    procedure OnAfterPurchRcptLineInsert(PurchaseLine: Record "Purchase Line"; var PurchRcptLine: Record "Purch. Rcpt. Line"; ItemLedgShptEntryNo: Integer; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSupressed: Boolean; PurchInvHeader: Record "Purch. Inv. Header"; var TempTrackingSpecification: Record "Tracking Specification" temporary; PurchRcptHeader: Record "Purch. Rcpt. Header"; TempWhseRcptHeader: Record "Warehouse Receipt Header"; xPurchLine: Record "Purchase Line"; var TempPurchLineGlobal: Record "Purchase Line" temporary)
    var
        PurchHdr: Record 38;
        DocNo: Code[20];
        VendorNo: Code[20];
        PurchLine: Record 39;
        PurchLinecheck: Record 39;
        PurchaseHeader: Record 38;
        Itemcharge: Record "Item Charge";
        NoSeriesMgm: Codeunit NoSeriesManagement;
        ItemChargeAssignPurchInv: Record 5805;

        GenPostSetup: Record "General Posting Setup";
        LocVendor: Record 23;
        ItemChargeAssignPurch: Record "Item Charge Assignment (Purch)";
        ItemChargeAssignPurchForCrMemo: Record "Item Charge Assignment (Purch)";
    begin
        if PurchaseHeader.Get(PurchaseLine."Document Type", PurchaseLine."Document No.") then;
        //if (PurchaseHeader."Charge Item Type KPMG" <> PurchaseHeader."Charge Item Type KPMG"::Provisional) then
        //   exit;
        if PurchRcptLine.Type <> PurchRcptLine.Type::"Charge (Item)" then
            exit;
        itemcharge.Get(PurchaseLine."No.");
        if not Itemcharge.IsProvisionCharge then
            exit;
        if Itemcharge."Vendor No" = '' then
            exit;

        if LocVendor.Get(PurchaseHeader."Buy-from Vendor No.") then;

        /* ItemChargeAssignPurch.SetCurrentKey("Applies-to Doc. Type", "Applies-to Doc. No.", "Applies-to Doc. Line No.");
         ItemChargeAssignPurch.SetRange("Document No.", PurchaseHeader."No.");
         if ItemChargeAssignPurch.FindSet() then
             repeat*/
        if Itemcharge."Vendor No" <> VendorNo then begin
            PurchHdr.Init();
            VendorNo := Itemcharge."Vendor No";
            //PurchHdr.TransferFields(PurchaseHeader);
            DocNo := NoSeriesMgm.GetNextNo('P-INV', WorkDate(), true);
            PurchHdr."No." := DocNo;
            PurchHdr."Document Type" := PurchHdr."Document Type"::Invoice;
            PurchHdr."No." := DocNo;
            PurchHdr.Validate(Status, PurchHdr.Status::Open);
            PurchHdr.Validate("Buy-from Vendor No.", Itemcharge."Vendor No");
            PurchHdr.Validate("Charge Item Type KPMG", PurchHdr."Charge Item Type KPMG"::Provisional);
            PurchHdr.Validate("Posting Date", PurchRcptHeader."Posting Date");
            PurchHdr.Validate("Vendor Invoice No.", 'PROV-' + PurchRcptHeader."No.");
            PurchHdr.Validate("Document Date", PurchRcptHeader."Posting Date");
            PurchHdr.Validate("Payment Terms Code", PurchRcptHeader."Payment Terms Code");
            PurchHdr.Validate("Location Code", PurchRcptHeader."Location Code");
            PurchHdr.Validate("Order Date", PurchRcptHeader."Order Date");
            PurchHdr.Validate("Provisional Inv", true);
            PurchHdr.Validate("Currency Code", PurchRcptHeader."Currency Code");
            PurchHdr.Insert();
        end;
        //PurchHdr.Modify();
        //check PO item line
        PurchLinecheck.Reset();
        PurchLinecheck.SetRange("Document No.", PurchaseHeader."No.");
        PurchLinecheck.SetRange(Type, PurchLinecheck.Type::Item);
        if PurchLinecheck.FindFirst() then;

        PurchLine.Init();
        PurchLine."Document Type" := PurchLine."Document Type"::Invoice;
        PurchLine."Document No." := DocNo;
        PurchLine."Line No." := 10000;
        PurchLine.Type := PurchLine.Type::"Charge (Item)";

        PurchLine.Validate("No.", PurchRcptLine."No.");
        PurchLine.Validate(Quantity, PurchLinecheck."Qty. to Receive");
        //PurchLine.Validate("Qty. to Invoice", PurchRcptLine.Quantity);
        PurchLine.Validate("Direct Unit Cost", PurchRcptLine."Direct Unit Cost");
        PurchLine.Insert(true);

        // PurchInvLine.Validate("Qty. to Receive", PurchLine."Qty. to Receive");
        // PurchInvLine.Validate("Qty. to Invoice", PurchLine."Qty. to Invoice");
        // PurchInvLine.Validate("Qty. to Assign", PurchLine."Qty. to Assign");
        // // PurchLine.Validate("Direct Unit Cost", TotalAmt);

        //Item charge
        Clear(ItemChargeAssignPurchInv);
        ItemChargeAssignPurchInv.Init();
        ItemChargeAssignPurchInv."Document Type" := ItemChargeAssignPurchInv."Document Type"::Invoice;
        ItemChargeAssignPurchInv."Document No." := DocNo;

        ItemChargeAssignPurchInv."Document Line No." := PurchLinecheck."Line No.";
        ItemChargeAssignPurchInv."Line No." := 10000;
        ItemChargeAssignPurchInv."Item Charge No." := Itemcharge."No.";
        ItemChargeAssignPurchInv.Validate("Applies-to Doc. Type", ItemChargeAssignPurchInv."Applies-to Doc. Type"::Receipt);

        ItemChargeAssignPurchInv.Validate("Applies-to Doc. No.", PurchRcptHeader."No.");
        ItemChargeAssignPurchInv."Applies-to Doc. Line No." := 10000;//ItemChargeAssignPurch."Applies-to Doc. Line No.";
                                                                     // ItemChargeAssignPurchInv.Validate("Applies-to Doc. Line No.", ItemChargeAssignPurch."Applies-to Doc. Line No.");
        ItemChargeAssignPurchInv."Item No." := PurchLinecheck."No.";
        ItemChargeAssignPurchInv.Validate("Qty. to Assign", PurchLinecheck."Qty. to Receive");
        // ItemChargeAssignPurchInv."Unit Cost" := PurchLinecheck."Unit Cost";
        ItemChargeAssignPurchInv.Validate("Qty. to Handle", PurchLinecheck."Qty. to Receive");
        ItemChargeAssignPurchInv."Amount to Assign" := PurchLine."Line Amount";
        ItemChargeAssignPurchInv.Validate("Amount to Handle", PurchLine."Line Amount");
        // ItemChargeAssignPurchInv.Validate("Amount to Assign", PurchLinecheck."Line Amount");

        //end;
        ItemChargeAssignPurchInv.Insert();

        PurchHdr.SetRange("No.", DocNo);
        if PurchHdr.FindFirst() then
            CODEUNIT.Run(CODEUNIT::"Purch.-Post", PurchHdr);
        //  end;
        // until ItemChargeAssignPurch.next = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeInsertReceiptLine', '', true, true)]
    local procedure OnBeforeInsertReceiptLine(var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchLine: Record "Purchase Line"; var CostBaseAmount: Decimal; var IsHandled: Boolean);
    var
        // PurchLine: Record 39;
        PurchHeader: Record 38;
        itemcharge: Record "Item Charge";
    begin
        if PurchHeader.Get(PurchHeader."Document Type"::Invoice, PurchLine."Document No.") then;
        PurchLine.Reset();
        PurchLine.SetRange(PurchLine."Document Type", PurchLine."Document Type"::Invoice);
        PurchLine.SetRange("Document No.", PurchHeader."No.");
        PurchLine.SetRange(Type, PurchLine.Type::"Charge (Item)");
        if PurchLine.FindSet then
            repeat
                if itemcharge.Get(PurchLine."No.") then;
                if itemcharge."Vendor No" <> '' then
                    IsHandled := true;
            until PurchLine.Next = 0;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterGLFinishPosting', '', true, true)]
    local procedure OnAfterGLFinishPosting(GLEntry: Record "G/L Entry"; var GenJnlLine: Record "Gen. Journal Line"; var IsTransactionConsistent: Boolean; FirstTransactionNo: Integer; var GLRegister: Record "G/L Register"; var TempGLEntryBuf: Record "G/L Entry" temporary; var NextEntryNo: Integer; var NextTransactionNo: Integer)
    var
        SingleinstanceCU: Codeunit 70103;
    begin
        SingleinstanceCU.InsertGL(GLEntry);

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchInvLineInsert', '', true, true)]
    local procedure OnAfterPurchInvLineInsert(var PurchInvLine: Record "Purch. Inv. Line"; PurchInvHeader: Record "Purch. Inv. Header"; PurchLine: Record "Purchase Line"; ItemLedgShptEntryNo: Integer; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSupressed: Boolean; PurchHeader: Record "Purchase Header"; PurchRcptHeader: Record "Purch. Rcpt. Header"; TempWhseRcptHeader: Record "Warehouse Receipt Header"; var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line")
    begin
        /// CreateProvisionalEntry(PurchInvLine, PurchLine);
    end;





    //
    //temp change_BRB LOCAL PROCEDURE CreateProvisionalEntry(VAR PurchRcptLine: Record 121; VAR LocPurchLine: Record 39);
    LOCAL PROCEDURE CreateProvisionalEntry(VAR PurchRcptLine: Record 123; VAR LocPurchLine: Record 39);
    VAR
        InvPostSetup: Record 5813;
        GenPostSetup: Record 252;
        GenJournalLine1: Record 81;
        GenJnlLine: Record 81;
        LocLineNo: Integer;
        RecItemCharge: Record 5800;
        LocVendor: Record 23;
        LocPurchRecLine: Record 123;
        LocPurchRecpLine: Record 123;
        Locitem: Record 27;
        GenJnlPostLine: Codeunit 12;
    BEGIN
        //001
        LocPurchRecpLine.RESET;
        LocPurchRecpLine.SETRANGE(LocPurchRecpLine."Document No.", PurchRcptLine."Document No.");
        LocPurchRecpLine.SETRANGE(LocPurchRecpLine.Type, LocPurchRecpLine.Type::Item);
        IF LocPurchRecpLine.FINDFIRST THEN BEGIN
            Locitem.RESET;
            Locitem.GET(LocPurchRecpLine."No.");
        END;
        InvPostSetup.RESET;
        InvPostSetup.SETRANGE(InvPostSetup."Location Code", PurchRcptLine."Location Code");
        InvPostSetup.SETRANGE(InvPostSetup."Invt. Posting Group Code", Locitem."Inventory Posting Group");
        IF InvPostSetup.FINDFIRST THEN BEGIN
            InvPostSetup.TESTFIELD(InvPostSetup."Provision Inventory (Interim)");
            InvPostSetup.TESTFIELD(InvPostSetup."Provision Inventory");
        END;

        RecItemCharge.RESET;
        IF RecItemCharge.GET(PurchRcptLine."No.") THEN
            RecItemCharge.TESTFIELD(RecItemCharge."Provision Direct Cost Applied");

        LocVendor.RESET;
        LocVendor.GET(PurchRcptLine."Buy-from Vendor No.");
        //  if LocVendor."Charge Item Type KPMG" <> LocVendor."Charge Item Type KPMG"::Provisional then
        //     exit;

        GenPostSetup.RESET;
        GenPostSetup.SETRANGE(GenPostSetup."Gen. Bus. Posting Group", LocVendor."Gen. Bus. Posting Group");
        GenPostSetup.SETRANGE(GenPostSetup."Gen. Prod. Posting Group", RecItemCharge."Gen. Prod. Posting Group");
        IF GenPostSetup.FINDFIRST THEN BEGIN
            GenPostSetup.TESTFIELD(GenPostSetup."Provision For Purchase Acc.");
        END
        ELSE
            ERROR('General Posting setup is missing for %1 Gen.bus.posting Group and %2 Gen.Prod.Posting group', LocVendor."Gen. Bus. Posting Group", RecItemCharge."Gen. Prod. Posting Group");
        LocPurchRecLine.RESET;
        LocPurchRecLine.SETRANGE(LocPurchRecLine."Document No.", PurchRcptLine."Document No.");
        LocPurchRecLine.SETRANGE(LocPurchRecLine.Type, LocPurchRecLine.Type::"Charge (Item)");
        IF LocPurchRecLine.FINDFIRST THEN BEGIN
            GenJournalLine1.SETRANGE("Journal Template Name", 'GENERAL');
            GenJournalLine1.SETRANGE("Journal Batch Name", 'DEFAULT');
            IF GenJournalLine1.FINDLAST THEN
                LocLineNo := GenJournalLine1."Line No." + 10000
            ELSE
                LocLineNo := 10000;

            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := 'GENERAL';
            GenJnlLine."Journal Batch Name" := 'DEFAULT';
            GenJnlLine."Line No." := LocLineNo;
            GenJnlLine."Posting Date" := PurchRcptLine."Posting Date";
            GenJnlLine."Document Date" := PurchRcptLine."Posting Date";
            GenJnlLine.Description := PurchRcptLine."No.";
            GenJnlLine."Source Code" := 'PROVISION';
            //GenJnlLine."Document Type" := GenJnlLineDocType;
            ///_BRB GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice;
            GenJnlLine."Document No." := PurchRcptLine."Document No.";
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No." := InvPostSetup."Provision Inventory (Interim)";

            GenJnlLine."External Document No." := PurchRcptLine."Document No.";

            // GenJnlLine.Amount := PurchRcptLine."Direct Unit Cost" * PurchRcptLine.Quantity;
            GenJnlLine.Amount := LocPurchLine."Unit Cost (LCY)" * LocPurchLine."Qty. to Receive";
            GenJnlLine.VALIDATE(GenJnlLine.Amount);
            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
            GenJnlLine."Bal. Account No." := GenPostSetup."Provision For Purchase Acc.";
            GenJnlLine."Dimension Set ID" := PurchRcptLine."Dimension Set ID";
            GenJnlLine."Location Code" := PurchRcptLine."Location Code";
            //GenJnlLine."Com Code" := PurchRcptLine."No.";
            GenJnlLine.INSERT;              //Insert 1
            GenJnlPostLine.RunWithCheck(GenJnlLine);
            GenJnlLine.DELETE;


            RecItemCharge.RESET;
            IF RecItemCharge.GET(PurchRcptLine."No.") THEN;

            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := 'GENERAL';
            GenJnlLine."Journal Batch Name" := 'DEFAULT';
            GenJnlLine."Line No." := LocLineNo + 10000;
            GenJnlLine."Posting Date" := PurchRcptLine."Posting Date";
            GenJnlLine."Document Date" := PurchRcptLine."Posting Date";

            GenJnlLine.Description := PurchRcptLine."No.";
            GenJnlLine."Source Code" := 'PROVISION';
            /// GenJnlLine."Document Type" := GenJnlLineDocType;
            ///_BRB GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice;      //
            GenJnlLine."Document No." := PurchRcptLine."Document No.";
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No." := InvPostSetup."Inventory Account";
            GenJnlLine."External Document No." := PurchRcptLine."Document No.";
            // GenJnlLine.Amount := PurchRcptLine."Direct Unit Cost" * PurchRcptLine.Quantity;
            GenJnlLine.Amount := LocPurchLine."Unit Cost (LCY)" * LocPurchLine."Qty. to Receive";
            GenJnlLine.VALIDATE(GenJnlLine.Amount);
            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
            GenJnlLine."Bal. Account No." := RecItemCharge."Provision Direct Cost Applied";
            GenJnlLine."Dimension Set ID" := PurchRcptLine."Dimension Set ID";
            GenJnlLine."Location Code" := PurchRcptLine."Location Code";
            //GenJnlLine."Com Code" := PurchRcptLine."No.";
            GenJnlLine.INSERT;              //Insert 2

            GenJnlPostLine.RunWithCheck(GenJnlLine);
            GenJnlLine.DELETE;
        END;
    END;
    /*
       LOCAL PROCEDURE CreateInvoiceChargeProvisionalEntry(VAR PurchInvLine: Record 123; VAR PurchIetmCharge: Record 5805);
       VAR
           InvPostSetup: Record 5813;
           GenPostSetup: Record 252;
           GenJournalLine1: Record 81;
           GenJnlLine: Record 81;
           LocLineNo: Integer;
           RecItemCharge: Record 5800;
           GLEntry: Record 17;
           GLSetup: Record 98;
           LocVendor: Record 23;
           LocItemCharge: Record 5800;
           RecVendorGRN: Record 23;
           LocRecptHeader: Record 120;
           GenSetup: Record 98;
           PurchinvHead: Record 122;
           LocPurchRecpLine: Record 121;
           LocItem: Record 27;
           LocLineNo1: Integer;
       BEGIN
           LocPurchRecpLine.RESET;
           LocPurchRecpLine.SETRANGE(LocPurchRecpLine."Document No.", PurchIetmCharge."Applies-to Doc. No.");
           LocPurchRecpLine.SETRANGE(LocPurchRecpLine.Type, LocPurchRecpLine.Type::Item);
           IF LocPurchRecpLine.FINDFIRST THEN BEGIN
               LocItem.RESET;
               LocItem.GET(LocPurchRecpLine."No.");
           END;
           InvPostSetup.RESET;
           InvPostSetup.SETRANGE(InvPostSetup."Location Code", LocPurchRecpLine."Location Code");
           InvPostSetup.SETRANGE(InvPostSetup."Invt. Posting Group Code", LocItem."Inventory Posting Group");
           IF InvPostSetup.FINDFIRST THEN BEGIN
               InvPostSetup.TESTFIELD(InvPostSetup."Provision Inventory (Interim)");
               InvPostSetup.TESTFIELD(InvPostSetup."Provision Inventory");
           END;


           LocVendor.RESET;
           LocVendor.GET(PurchInvLine."Buy-from Vendor No.");
           LocItemCharge.RESET;
           LocItemCharge.GET(PurchIetmCharge."Item Charge No.");
           LocItemCharge.TESTFIELD(LocItemCharge."Provision Direct Cost Applied");
           GenPostSetup.RESET;
           GenPostSetup.SETRANGE(GenPostSetup."Gen. Bus. Posting Group", LocVendor."Gen. Bus. Posting Group");
           //GenPostSetup.SETRANGE(GenPostSetup."Gen. Bus. Posting Group",RecVendorGRN."Gen. Bus. Posting Group");
           GenPostSetup.SETRANGE(GenPostSetup."Gen. Prod. Posting Group", LocItemCharge."Gen. Prod. Posting Group");
           IF GenPostSetup.FINDFIRST THEN
               GenPostSetup.TESTFIELD(GenPostSetup."Provision For Purchase Acc.")
           ELSE
               ERROR('General Posting setup is missing for %1 Gen.bus.posting Group and %2 Gen.Prod.Posting group', LocVendor."Gen. Bus. Posting Group", LocItemCharge."Gen. Prod. Posting Group");

           GenSetup.RESET;
           GenSetup.GET;

           /*ProvisionAmount:=0;
           CLEAR(RecGLEntryProv);
           RecGLEntryProv.RESET;
           RecGLEntryProv.SETRANGE(RecGLEntryProv."Com Code",PurchIetmCharge."Item Charge No.");//11sep
           RecGLEntryProv.SETRANGE(RecGLEntryProv."Provisional Entry",TRUE);
           RecGLEntryProv.SETRANGE(RecGLEntryProv."Source Code",'PROVISION');
           RecGLEntryProv.SETRANGE(RecGLEntryProv."External Document No.",PurchIetmCharge."Applies-to Doc. No.");
           IF RecGLEntryProv.FINDSET THEN
           REPEAT
             ProvisionAmount:=ProvisionAmount+RecGLEntryProv.Amount;
           UNTIL RecGLEntryProv.NEXT=0;

           GLSetup.RESET;
           GLSetup.GET;
           GenJournalLine1.RESET;
           GenJournalLine1.SETRANGE("Journal Template Name", 'GENERAL');
           GenJournalLine1.SETRANGE("Journal Batch Name", 'DEFAULT');
           GenJournalLine1.SETRANGE(GenJournalLine1."Account No.", LocItemCharge."Provision Direct Cost Applied");
           GenJournalLine1.SETRANGE(GenJournalLine1."Source Code", 'PROVISION');
           GenJournalLine1.SETRANGE(GenJournalLine1."External Document No.", PurchIetmCharge."Applies-to Doc. No.");
           GenJournalLine1.SETRANGE(GenJournalLine1.Description, PurchIetmCharge."Item Charge No.");
           IF GenJournalLine1.FINDSET THEN
               REPEAT
                   GenAmount := GenAmount + GenJournalLine1.Amount;
               UNTIL GenJournalLine1.NEXT = 0;

           Finalprovision := ABS(ProvisionAmount) - GenAmount;
           PurchinvHead.RESET;
           PurchinvHead.SETRANGE(PurchinvHead."No.", PurchInvLine."Document No.");
           //PurchinvHead.SETRANGE(PurchinvHead.D);
           IF PurchinvHead.FINDFIRST THEN;

           IF ABS(Finalprovision) <> 0 THEN BEGIN
               GenJournalLine1.RESET;
               GenJournalLine1.SETRANGE("Journal Template Name", 'GENERAL');
               GenJournalLine1.SETRANGE("Journal Batch Name", 'DEFAULT');
               IF GenJournalLine1.FINDLAST THEN
                   LocLineNo := GenJournalLine1."Line No." + 10000
               ELSE
                   LocLineNo := 10000;


               GenJnlLine.INIT;
               GenJnlLine."Journal Template Name" := 'GENERAL';
               GenJnlLine."Journal Batch Name" := 'DEFAULT';
               GenJnlLine."Line No." := LocLineNo;
               GenJnlLine."Posting Date" := PurchInvLine."Posting Date";
               GenJnlLine."Document Date" := PurchInvLine."Posting Date";
               GenJnlLine.Description := PurchInvLine."No.";
               GenJnlLine."Source Code" := 'PROVISION';
             ///  GenJnlLine."Document Type" := GenJnlLineDocType;
               GenJnlLine."Document No." := PurchInvLine."Document No.";
               GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
               GenJnlLine."Account No." := GenPostSetup."Provision For Purchase Acc.";
               GenJnlLine."External Document No." := PurchIetmCharge."Applies-to Doc. No.";
               GenJnlLine."Currency Code" := PurchinvHead."Currency Code";
               GenJnlLine.VALIDATE(GenJnlLine.Amount, PurchIetmCharge."Amount to Assign");
               IF GenJnlLine."Amount (LCY)" >= ABS(Finalprovision) THEN
                   GenJnlLine.VALIDATE(GenJnlLine."Amount (LCY)", ABS(Finalprovision));

               GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
               GenJnlLine."Bal. Account No." := InvPostSetup."Provision Inventory (Interim)";
               GenJnlLine."Dimension Set ID" := PurchInvLine."Dimension Set ID";
               GenJnlLine."Location Code" := PurchInvLine."Location Code";
               //GenJnlLine."Com Code" := PurchInvLine."No.";
               GenJnlLine.INSERT;
               // GenJnlPostLine.RunWithCheck(GenJnlLine);
               // GenJnlLine.DELETE;

               RecItemCharge.RESET;
               IF RecItemCharge.GET(PurchInvLine."No.") THEN;

               GenJnlLine.INIT;
               GenJnlLine."Journal Template Name" := 'GENERAL';
               GenJnlLine."Journal Batch Name" := 'DEFAULT';
               GenJnlLine."Line No." := LocLineNo + 10000;
               GenJnlLine."Posting Date" := PurchInvLine."Posting Date";
               GenJnlLine."Document Date" := PurchInvLine."Posting Date";
               GenJnlLine.Description := PurchInvLine."No.";
               GenJnlLine."Source Code" := 'PROVISION';
               GenJnlLine."Document Type" := GenJnlLineDocType;
               GenJnlLine."Document No." := PurchInvLine."Document No.";
               GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
               GenJnlLine."Account No." := RecItemCharge."Provision Direct Cost Applied";
               GenJnlLine."External Document No." := PurchIetmCharge."Applies-to Doc. No.";
               GenJnlLine."Currency Code" := PurchinvHead."Currency Code";
               GenJnlLine.VALIDATE(GenJnlLine.Amount, PurchIetmCharge."Amount to Assign");
               IF GenJnlLine."Amount (LCY)" >= ABS(Finalprovision) THEN
                   GenJnlLine.VALIDATE(GenJnlLine."Amount (LCY)", ABS(Finalprovision));

               GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
               GenJnlLine."Bal. Account No." := InvPostSetup."Provision for Inventory";
               GenJnlLine."Dimension Set ID" := PurchInvLine."Dimension Set ID";
               GenJnlLine."Location Code" := PurchInvLine."Location Code";
               GenJnlLine."Com Code" := PurchInvLine."No.";
               GenJnlLine.INSERT;
               //  GenJnlPostLine.RunWithCheck(GenJnlLine);
               //  GenJnlLine.DELETE;

               //sale prov reversal
               SaleProvisionAmount := 0;
               CLEAR(RecGLEntryProv);
               SaleProvisionAmount := PurchIetmCharge."Amount to Assign";
               GlSaleTotal := 0;
               GLSale.RESET;
               GLSale.SETRANGE(GLSale."COGS Provision Entry", TRUE);
               GLSale.SETRANGE(GLSale."Source Code", 'SALEPROV');
               GLSale.SETRANGE(GLSale."External Document No.", PurchIetmCharge."Applies-to Doc. No.");
               IF GLSale.FINDSET THEN
                   REPEAT
                       GlSaleTotal := GlSaleTotal + GLSale.Amount;  //3300  pending sale prov
                   UNTIL GLSale.NEXT = 0;

               IF ABS(GlSaleTotal) > 0 THEN BEGIN
                   RecGLEntryProv.RESET;
                   RecGLEntryProv.SETRANGE(RecGLEntryProv."COGS Provision Entry", TRUE);
                   RecGLEntryProv.SETRANGE(RecGLEntryProv."Source Code", 'SALEPROV');
                   RecGLEntryProv.SETRANGE(RecGLEntryProv."External Document No.", PurchIetmCharge."Applies-to Doc. No.");
                   RecGLEntryProv.SETFILTER(RecGLEntryProv.Amount, '<%1', 0);
                   IF RecGLEntryProv.FINDSET THEN
                       REPEAT
                           SaleShipTtoal := 0;
                           SalesAllotedamount := 0;
                           GLSale.RESET;
                           GLSale.SETRANGE(GLSale."COGS Provision Entry", TRUE);
                           GLSale.SETRANGE(GLSale."Source Code", 'SALEPROV');
                           GLSale.SETRANGE(GLSale."Sales Doc No", RecGLEntryProv."Sales Doc No");
                           IF GLSale.FINDSET THEN
                               REPEAT
                                   SaleShipTtoal := SaleShipTtoal + GLSale.Amount;
                               UNTIL GLSale.NEXT = 0;  //1400

                           FinalShiptotal := 0;
                           GenJnlSales.RESET;
                           GenJnlSales.SETRANGE(GenJnlSales."Journal Template Name", 'GENERAL');
                           GenJnlSales.SETRANGE(GenJnlSales."Journal Batch Name", 'DEFAULT');
                           GenJnlSales.SETRANGE(GenJnlSales."Source Code", 'SALEPROV');
                           GenJnlSales.SETRANGE(GenJnlSales."Sales Doc No", RecGLEntryProv."Sales Doc No");
                           IF GenJnlSales.FINDSET THEN
                               REPEAT
                                   SalesAllotedamount := SalesAllotedamount + GenJnlSales.Amount;
                               UNTIL GenJnlSales.NEXT = 0;

                           FinalShiptotal := ABS(SaleShipTtoal) - ABS(SalesAllotedamount);

                           SaleFinalprovision := 0;
                           IF ABS(FinalShiptotal) >= SaleProvisionAmount THEN
                               SaleFinalprovision := SaleProvisionAmount
                           ELSE
                               SaleFinalprovision := ABS(FinalShiptotal);

                           IF SaleFinalprovision <> 0 THEN BEGIN
                               GenJournalLine1.RESET;
                               GenJournalLine1.SETRANGE("Journal Template Name", 'GENERAL');
                               GenJournalLine1.SETRANGE("Journal Batch Name", 'DEFAULT');
                               IF GenJournalLine1.FINDLAST THEN
                                   LocLineNo1 := GenJournalLine1."Line No." + 10000
                               ELSE
                                   LocLineNo1 := 10000;

                               GenJnlLine.RESET;
                               GenJnlLine.INIT;
                               GenJnlLine."Journal Template Name" := 'GENERAL';
                               GenJnlLine."Journal Batch Name" := 'DEFAULT';
                               GenJnlLine."Line No." := LocLineNo1;
                               GenJnlLine."Posting Date" := PurchInvLine."Posting Date";
                               GenJnlLine."Document Date" := PurchInvLine."Posting Date";
                               GenJnlLine.Description := PurchInvLine."No.";
                               GenJnlLine."Document Type" := GenJnlLineDocType;
                               GenJnlLine."Document No." := PurchInvLine."Document No.";
                               GenJnlLine."Source Code" := 'SALEPROV';
                               GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                               GenJnlLine."Account No." := RecGLEntryProv."G/L Account No.";
                               GenJnlLine."External Document No." := PurchIetmCharge."Applies-to Doc. No.";
                               ;
                               GenJnlLine.Amount := SaleFinalprovision;
                               GenJnlLine.VALIDATE(GenJnlLine.Amount);
                               GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                               GenJnlLine."Bal. Account No." := RecGLEntryProv."Bal. Account No.";
                               GenJnlLine."Dimension Set ID" := PurchInvLine."Dimension Set ID";
                               GenJnlLine."Location Code" := PurchInvLine."Location Code";
                               GenJnlLine."Com Code" := RecGLEntryProv."Com Code";
                               GenJnlLine."Sales Doc No" := RecGLEntryProv."Document No.";
                               GenJnlLine.INSERT;
                           END;
                           SaleProvisionAmount := SaleProvisionAmount - SaleFinalprovision;

                       UNTIL (RecGLEntryProv.NEXT = 0) OR (SaleProvisionAmount = 0);
               END;//

               //sale Prov Reversal
           END;
       END;
       */


}

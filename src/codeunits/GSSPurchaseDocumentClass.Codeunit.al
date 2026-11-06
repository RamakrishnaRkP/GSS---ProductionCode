codeunit 60101 GSSPurchaseDocumentClass
{
    #region Table-PurchaseHeader
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterInsertEvent', '', false, false)]
    local procedure GSS_OnAfterInsertEvent(var Rec: Record "Purchase Header"; RunTrigger: Boolean)
    begin
        if not RunTrigger then exit;
        ArchivePurchDocumentOnInsert(Rec);
    end;
    local procedure ArchivePurchDocumentOnInsert(var PurchaseHeader: Record "Purchase Header")
    var
        PurchPayableSetup: Record "Purchases & Payables Setup";
    begin
        if PurchPayableSetup.Get()then if PurchPayableSetup."GSSArch. Purch. Doc. On Insert" then ArchivePurchDocument(PurchaseHeader);
    end;
    local procedure ArchivePurchDocumentOnRelease(var PurchaseHeader: Record "Purchase Header")
    var
        PurchPayableSetup: Record "Purchases & Payables Setup";
    begin
        if PurchPayableSetup.Get()then if PurchPayableSetup."GSSArch. Purch. Doc. OnRelease" then ArchivePurchDocument(PurchaseHeader);
    end;
    local procedure ArchivePurchDocument(var PurchaseHeader: Record "Purchase Header")
    var
        ArchMgmt: Codeunit ArchiveManagement;
    begin
        Clear(ArchMgmt);
        ArchMgmt.AutoArchivePurchDocument(PurchaseHeader);
    end;
    #endregion 
    #region Purch-Post
    //Event OnBeforePostPurchaseDoc
    //Check for Purchaser Code before posting
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostPurchaseDoc', '', false, false)]
    local procedure GSS_OnBeforePostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; CommitIsSupressed: Boolean; var HideProgressWindow: Boolean; var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line")
    begin
        PurchaseHeader.TestField("Purchaser Code");
    end;
    //Event OnBeforeDeleteAfterPosting
    //Checks weather to skip document deletion after posting
    /*  [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeDeleteAfterPosting', '', false, false)]
     local procedure GSS_OnBeforeDeleteAfterPosting(var PurchaseHeader: Record "Purchase Header"; var PurchInvHeader: Record "Purch. Inv. Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var SkipDelete: Boolean; CommitIsSupressed: Boolean; var TempPurchLine: Record "Purchase Line" temporary)
     var
         PurchPayableSetup: Record "Purchases & Payables Setup";
     begin
         if PurchPayableSetup.Get() then
             if PurchPayableSetup."GSSSkip Delete After Post" then
                 SkipDelete := true;
     end;

     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterFinalizePostingOnBeforeCommit', '', false, false)]
     local procedure GSS_OnAfterFinalizePostingOnBeforeCommit(var PurchHeader: Record "Purchase Header"; var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchInvHeader: Record "Purch. Inv. Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var ReturnShptHeader: Record "Return Shipment Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PreviewMode: Boolean; CommitIsSupressed: Boolean; EverythingInvoiced: Boolean)
     var
         PurchRec: Record "Purchase Header";
     begin
         if not PreviewMode then
             if EverythingInvoiced then
                 if PurchRec.Get(PurchHeader."Document Type", PurchHeader."No.") then begin
                     PurchHeader.Status := PurchHeader.Status::"Completely Invoiced";
                     PurchHeader.Modify();
                 end;
     end; */
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeFinalizePosting', '', false, false)]
    local procedure KeepPurchOrdersAfterInvoiced(var PurchaseHeader: Record "Purchase Header"; var EverythingInvoiced: Boolean)
    var
        PurchPayableSetup: Record "Purchases & Payables Setup";
    begin
        if EverythingInvoiced then begin
            PurchaseHeader.Status:=PurchaseHeader.Status::"Completely Invoiced";
            PurchaseHeader.Modify();
        end;
        if PurchPayableSetup.Get()then if PurchPayableSetup."GSSSkip Delete After Post" then EverythingInvoiced:=false;
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnCheckAndUpdateOnAfterArchiveUnpostedOrder', '', false, false)]
    local procedure OnCheckAndUpdateOnAfterArchiveUnpostedOrder(var PurchHeader: Record "Purchase Header"; Currency: Record "Currency"; PreviewMode: Boolean)
    begin
        if(not PurchHeader.Receive) and (not PurchHeader.Ship)then if PurchHeader.Invoice then ArchivePurchDocument(PurchHeader);
    end;
    #endregion 
    #region ReleasePurchaseDocument
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnAfterReleasePurchaseDoc', '', false, false)]
    local procedure GSS_OnAfterReleasePurchaseDoc(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; var LinesWereModified: Boolean)
    begin
        PurchaseHeader.TestField("Purchaser Code");
        ArchivePurchDocumentOnRelease(PurchaseHeader);
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnBeforeReopenPurchaseDoc', '', false, false)]
    local procedure GSS_OnBeforeReopenPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; var IsHandled: Boolean)
    begin
        if PurchaseHeader.Status = PurchaseHeader.Status::"Completely Invoiced" then Error(Text50100);
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnAfterReopenPurchaseDoc', '', false, false)]
    local procedure OnAfterReopenPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean)
    begin
        if PreviewMode then exit;
        ArchivePurchDocument(PurchaseHeader);
    end;
    #endregion 
    #region ApprovalsMgmt
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnAfterCheckPurchaseApprovalPossible', '', false, false)]
    local procedure OnAfterCheckPurchaseApprovalPossible(var PurchaseHeader: Record "Purchase Header")
    begin
        CheckMandatoryJobNoForTradePO(PurchaseHeader);
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnBeforeReleasePurchaseDoc', '', false, false)]
    local procedure OnBeforeReleasePurchaseDoc(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean)
    begin
        CheckMandatoryJobNoForTradePO(PurchaseHeader);
    end;
    procedure CheckMandatoryJobNoForTradePO(var PurchaseHeader: Record "Purchase Header")
    var
        GenBusPostingGroup: Record "Gen. Business Posting Group";
    begin
        if not(PurchaseHeader."Document Type" in[PurchaseHeader."Document Type"::Order])then exit;
        if GenBusPostingGroup.Get(PurchaseHeader."Gen. Bus. Posting Group")then if GenBusPostingGroup."GSSJob No. Req. for PO" then PurchaseHeader.TestField("GSSJob No.");
    end;
    #endregion 
    var Text50100: TextConst ENU = 'Completely Invoiced Order cannot be Reopened.';
}

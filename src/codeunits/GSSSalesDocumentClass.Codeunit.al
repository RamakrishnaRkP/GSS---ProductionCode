codeunit 60100 GSSSalesDocumentClass
{
    #region Table-SalesHeader
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterInsertEvent', '', false, false)]
    local procedure GSS_OnAfterInsertEvent(var Rec: Record "Sales Header"; RunTrigger: Boolean)
    var
    begin
        if not RunTrigger then exit;
        ArchiveSalesDocumetOnInsert(Rec);
    end;
    local procedure ArchiveSalesDocumetOnInsert(var SalesHeader: Record "Sales Header")
    var
        SaleRecSetup: Record "Sales & Receivables Setup";
    begin
        if SaleRecSetup.Get()then if SaleRecSetup."GSSArch. Sales Doc. On Insert" then begin
                ArchiveSalesDocumet(SalesHeader);
            end;
    end;
    local procedure ArchiveSalesDocumet(var SalesHeader: Record "Sales Header")
    var
        ArchMgmt: Codeunit ArchiveManagement;
    begin
        Clear(ArchMgmt);
        ArchMgmt.AutoArchiveSalesDocument(SalesHeader);
    end;
    local procedure ArchiveSalesDocumetOnRelease(var SalesHeader: Record "Sales Header")
    var
        SaleRecSetup: Record "Sales & Receivables Setup";
    begin
        if SaleRecSetup.Get()then if SaleRecSetup."GSSArch. Sales Doc. On Release" then begin
                ArchiveSalesDocumet(SalesHeader);
            end;
    end;
    #endregion 
    #region SalesQuote-To-Order
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", 'OnBeforeDeleteSalesQuote', '', false, false)]
    local procedure GSS_OnBeforeDeleteSalesQuote(var QuoteSalesHeader: Record "Sales Header"; var OrderSalesHeader: Record "Sales Header"; var IsHandled: Boolean; var SalesQuoteLine: Record "Sales Line")
    var
        SalesRecSetup: Record "Sales & Receivables Setup";
    begin
        if SalesRecSetup.Get()then if SalesRecSetup."GSSSkip Delete After SQConvert" then IsHandled:=true;
    end;
    #endregion 
    #region Sales-Post
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', false, false)]
    local procedure GSS_OnBeforePostSalesDoc(var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var HideProgressWindow: Boolean)
    begin
        if SalesHeader.Status = SalesHeader.Status::"Completely Invoiced" then Error('Order completely invoiced already!');
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeFinalizePosting', '', false, false)]
    local procedure KeepSalesOrdersAfterInvoiced(var SalesHeader: Record "Sales Header"; var EverythingInvoiced: Boolean)
    var
        SalesRecSetup: Record "Sales & Receivables Setup";
    begin
        if EverythingInvoiced then begin
            SalesHeader.Status:=SalesHeader.Status::"Completely Invoiced";
            SalesHeader.Modify();
        end;
        if SalesRecSetup.Get()then if SalesRecSetup."GSSSkip Delete After Post" then EverythingInvoiced:=false;
    end;
    /* [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeDeleteAfterPosting', '', false, false)]
    local procedure GSS_OnBeforeDeleteAfterPosting(var SalesHeader: Record "Sales Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var SkipDelete: Boolean; CommitIsSuppressed: Boolean; EverythingInvoiced: Boolean; var TempSalesLineGlobal: Record "Sales Line" temporary)
    var
        SalesRecSetup: Record "Sales & Receivables Setup";
        SalesLines: Record "Sales Line";
    begin
        if SalesRecSetup.Get() then
            if SalesRecSetup."GSSSkip Delete After Post" then
                SkipDelete := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterFinalizePostingOnBeforeCommit', '', false, false)]
    local procedure GSS_OnAfterFinalizePostingOnBeforeCommit(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var ReturnReceiptHeader: Record "Return Receipt Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; WhseShip: Boolean; WhseReceive: Boolean; var EverythingInvoiced: Boolean)
    var
        SalesRec: Record "Sales Header";
    begin
        if not PreviewMode then
            if EverythingInvoiced then
                //checking if the document exists, if the document is deleted, we cannot modify the document.
                if SalesRec.Get(SalesHeader."Document Type", SalesHeader."No.") then begin
                    SalesHeader.Status := SalesHeader.Status::"Completely Invoiced";
                    SalesHeader.Modify();
                end;
    end; */
    #endregion 
    #region ReleaseSalesDocument
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnBeforeReopenSalesDoc', '', false, false)]
    local procedure GSS_OnBeforeReopenSalesDoc(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; var IsHandled: Boolean)
    begin
        if SalesHeader.Status = SalesHeader.Status::"Completely Invoiced" then Error(Text50100);
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnAfterReleaseSalesDoc', '', false, false)]
    local procedure GSS_OnAfterReleaseSalesDoc(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; var LinesWereModified: Boolean)
    begin
        if not PreviewMode then ArchiveSalesDocumetOnRelease(SalesHeader);
    end;
    #endregion 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnInsertInvoiceHeaderOnBeforeSalesInvHeaderTransferFields', '', false, false)]
    local procedure OnInsertInvoiceHeaderOnBeforeSalesInvHeaderTransferFields(var SalesHeader: Record "Sales Header")
    var
        PaymentTermsRec: Record "Payment Terms";
        CurrLineVAT: Decimal;
        CurrSL: Record "Sales Line";
        CurrentInvoiceValue: Decimal;
        CustomerRec: Record Customer;
        JobRec: Record Job;
    begin
        Clear(CurrentInvoiceValue);
        Clear(CurrLineVAT);
        if JobRec.Get(SalesHeader."GSSJob No.")then begin
            CurrSL.Reset();
            CurrSL.SetRange("Document No.", SalesHeader."No.");
            if CurrSL.FindSet()then repeat if((SalesHeader."Currency Code" <> '') and (SalesHeader."Currency Factor" <> 0))then CurrLineVAT:=((((CurrSL."Qty. to Invoice") * CurrSL."Unit Price") / SalesHeader."Currency Factor") * CurrSL."VAT %") / 100
                    else
                        CurrLineVAT:=(((CurrSL."Qty. to Invoice") * CurrSL."Unit Price") * CurrSL."VAT %") / 100;
                    if((SalesHeader."Currency Code" <> '') and (SalesHeader."Currency Factor" <> 0))then CurrentInvoiceValue+=(((CurrSL."Qty. to Invoice") * CurrSL."Unit Price") / SalesHeader."Currency Factor") + CurrLineVAT
                    else
                        CurrentInvoiceValue+=((CurrSL."Qty. to Invoice") * CurrSL."Unit Price") + CurrLineVAT;
                until CurrSL.Next() = 0;
            if CustomerRec.Get(SalesHeader."Sell-to Customer No.")then begin
                CustomerRec.CalcFields("Balance (LCY)");
                if(CustomerRec."Balance (LCY)" + CurrentInvoiceValue) > CustomerRec."Credit Limit (LCY)" then if not JobRec."Invoice Exception allowed" then Error('Invoice cannot be done as it requires Finance Approval for Credit Limit');
            end;
        end;
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeInsertInvoiceHeader', '', false, false)]
    local procedure OnBeforeInsertInvoiceHeader(SalesHeader: Record "Sales Header"; var SalesInvHeader: Record "Sales Invoice Header"; var IsHandled: Boolean)
    var
        PaymentTermsRec: Record "Payment Terms";
        CurrLineVAT: Decimal;
        CurrSL: Record "Sales Line";
        CurrentInvoiceValue: Decimal;
        CustomerRec: Record Customer;
        JobRec: Record Job;
    begin
        Clear(CurrentInvoiceValue);
        Clear(CurrLineVAT);
        if JobRec.Get(SalesHeader."GSSJob No.")then begin
            CurrSL.Reset();
            CurrSL.SetRange("Document No.", SalesHeader."No.");
            if CurrSL.FindSet()then repeat if((SalesHeader."Currency Code" <> '') and (SalesHeader."Currency Factor" <> 0))then CurrLineVAT:=((((CurrSL."Qty. to Invoice") * CurrSL."Unit Price") / SalesHeader."Currency Factor") * CurrSL."VAT %") / 100
                    else
                        CurrLineVAT:=(((CurrSL."Qty. to Invoice") * CurrSL."Unit Price") * CurrSL."VAT %") / 100;
                    if((SalesHeader."Currency Code" <> '') and (SalesHeader."Currency Factor" <> 0))then CurrentInvoiceValue+=(((CurrSL."Qty. to Invoice") * CurrSL."Unit Price") / SalesHeader."Currency Factor") + CurrLineVAT
                    else
                        CurrentInvoiceValue+=((CurrSL."Qty. to Invoice") * CurrSL."Unit Price") + CurrLineVAT;
                until CurrSL.Next() = 0;
            if CustomerRec.Get(SalesHeader."Sell-to Customer No.")then begin
                CustomerRec.CalcFields("Balance (LCY)");
                JobRec."Invoice Value":=CustomerRec."Balance (LCY)" + CurrentInvoiceValue;
                JobRec.Modify();
            // Commit();
            end;
        end;
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Jnl.-Post", 'OnBeforeCode', '', false, false)]
    local procedure OnBeforeCode(var JobJnlLine: Record "Job Journal Line"; var HideDialog: Boolean; var SuppressCommit: Boolean)
    var
        JLERec: Record "Job Ledger Entry";
        JobRec: Record Job;
        CustomerRec: Record Customer;
        DeliverdNotInvoiced: Decimal;
        AllJobRec: Record Job;
        CurrentDeliveryValue: Decimal;
    begin
        if JobRec.Get(JobJnlLine."Job No.")then begin
            Clear(DeliverdNotInvoiced);
            Clear(CurrentDeliveryValue);
            AllJobRec.Setrange("Sell-to Customer No.", JobRec."Sell-to Customer No.");
            AllJobRec.SetFilter(GSSStatus, '%1|%2', AllJobRec.GSSStatus::"Pending Approval", AllJobRec.GSSStatus::Released);
            if AllJobRec.FindSet()then repeat JLERec.SetRange("Job No.", AllJobRec."No.");
                    if JLERec.FindSet()then repeat DeliverdNotInvoiced+=JLERec."Line Amount (LCY)";
                        until JLERec.Next() = 0;
                until AllJobRec.Next() = 0;
            CurrentDeliveryValue:=JobJnlLine."Line Amount (LCY)";
            if CustomerRec.Get(JobRec."Sell-to Customer No.")then begin
                CustomerRec.CalcFields("Balance (LCY)");
                JobRec."Shipment Value":=CustomerRec."Balance (LCY)" + CurrentDeliveryValue + DeliverdNotInvoiced;
                JobRec.Modify();
            //  Commit();
            end;
        end;
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Jnl.-Post", 'OnCodeOnBeforeConfirm', '', false, false)]
    local procedure OnCodeOnBeforeConfirm(JobJnlLine: Record "Job Journal Line"; var IsHandled: Boolean)
    var
        JLERec: Record "Job Ledger Entry";
        JobRec: Record Job;
        CustomerRec: Record Customer;
        DeliverdNotInvoiced: Decimal;
        AllJobRec: Record Job;
        CurrentDeliveryValue: Decimal;
        JPL: Record "Job Planning Line";
    begin
        if JobRec.Get(JobJnlLine."Job No.")then begin
            Clear(DeliverdNotInvoiced);
            Clear(CurrentDeliveryValue);
            AllJobRec.Setrange("Sell-to Customer No.", JobRec."Sell-to Customer No.");
            AllJobRec.SetFilter(GSSStatus, '%1|%2', AllJobRec.GSSStatus::"Pending Approval", AllJobRec.GSSStatus::Released);
            if AllJobRec.FindSet()then repeat JLERec.SetRange("Job No.", AllJobRec."No.");
                    if JLERec.FindSet()then repeat DeliverdNotInvoiced+=JLERec."Line Amount (LCY)";
                        until JLERec.Next() = 0;
                until AllJobRec.Next() = 0;
            CurrentDeliveryValue:=JobJnlLine."Line Amount (LCY)";
            JPL.Reset();
            JPL.SetRange("Job No.", JobRec."No.");
            JPL.SetRange(Type, JPL.Type::"G/L Account");
            JPL.SetRange("GSSRenewal Date", 0D);
            if JPL.FindFirst()then begin
                Error('Please enter the Renewal Date for line no. - %1', JPL."Line No.");
            end;
            if CustomerRec.Get(JobRec."Sell-to Customer No.")then begin
                if(((CustomerRec."Balance (LCY)" + CurrentDeliveryValue + DeliverdNotInvoiced) > CustomerRec."Credit Limit (LCY)") or (not JobRec."Customer PO Received"))then if not JobRec."Delivery Exception allowed" then Error('Shipment cannot be done as it requires Finance Approval for Credit Limit');
            end;
        end;
    end;
    var Text50100: TextConst ENU = 'Completely Invoiced Order cannot be Reopened.';
}

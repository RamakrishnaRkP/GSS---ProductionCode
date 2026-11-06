codeunit 60104 "GSSGenJnlPostLine"
{
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    begin
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitCustLedgEntry', '', false, false)]
    local procedure GSS_OnAfterInitCustLedgEntry(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        CustLedgerEntry."GSSHR Integration Entry":=GenJournalLine."GSSHR Integration Entry";
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitVendLedgEntry', '', false, false)]
    local procedure GSS_OnAfterInitVendLedgEntry(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        VendorLedgerEntry."GSSHR Integration Entry":=GenJournalLine."GSSHR Integration Entry";
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitBankAccLedgEntry', '', false, false)]
    local procedure GSS_OnAfterInitBankAccLedgEntry(var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        BankAccountLedgerEntry."GSSHR Integration Entry":=GenJournalLine."GSSHR Integration Entry";
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitEmployeeLedgerEntry', '', false, false)]
    local procedure GSS_OnAfterInitEmployeeLedgerEntry(var EmployeeLedgerEntry: Record "Employee Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        EmployeeLedgerEntry."GSSHR Integration Entry":=GenJournalLine."GSSHR Integration Entry";
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitGLEntry', '', false, false)]
    local procedure GSS_OnAfterInitGLEntry(var GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line"; Amount: Decimal; AddCurrAmount: Decimal; UseAddCurrAmount: Boolean; var CurrencyFactor: Decimal)
    begin
        GLEntry."GSSHR Integration Entry":=GenJournalLine."GSSHR Integration Entry";
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Get Receipt", 'OnAfterInsertInvoiceLineFromReceiptLine', '', false, false)]
    local procedure OnAfterInsertInvoiceLineFromReceiptLine(var PurchRcptLine: Record "Purch. Rcpt. Line"; var PurchLine: Record "Purchase Line"; PurchRcptLine2: Record "Purch. Rcpt. Line"; TransferLine: Boolean)
    var
        PurRcptHdr: Record "Purch. Rcpt. Header";
        PurHdr: Record "Purchase Header";
    begin
        if PurRcptHdr.Get(PurchLine."Receipt No.")then begin
            if PurHdr.Get(PurchLine."Document Type", PurchLine."Document No.")then begin
                PurHdr."GSSJob No.":=PurRcptHdr."GSSJob No.";
                PurHdr.Modify();
            end;
        end;
    end;
}

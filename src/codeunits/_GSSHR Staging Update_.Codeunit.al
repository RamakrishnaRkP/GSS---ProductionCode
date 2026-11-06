codeunit 60102 "GSSHR Staging Update"
{
    TableNo = "GSSHR Staging";

    trigger OnRun()
    begin
        CLEAR(GLSetup);
        GLSetup.GET;
        CLEAR(GenJournalLine);
        GenJournalLine.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Line No.");
        GenJournalLine.SETRANGE("Journal Template Name", 'GENERAL');
        GenJournalLine.SETRANGE("Journal Batch Name", 'HR');
        IF GenJournalLine.FINDLAST THEN LastLineNo:=GenJournalLine."Line No."
        ELSE
            LastLineNo:=0;
        //CLEAR(LastLineNo);
        CLEAR(HRStagingTable);
        HRStagingTable.COPYFILTERS(Rec);
        HRStagingTable.SETRANGE(NAV_ERROR, TRUE);
        IF HRStagingTable.FINDFIRST THEN ERROR(Text0001, HRStagingTable.BATCH_NUMBER);
        HRStagingTable.SETRANGE(NAV_ERROR);
        HRStagingTable.SETRANGE(NAV_PROCESSED, FALSE);
        HRStagingTable.SETRANGE(NAV_ERROR, FALSE);
        HRStagingTable.SETRANGE(NAV_SKIPPED, FALSE);
        IF HRStagingTable.FINDFIRST THEN REPEAT IF IsLineValid(HRStagingTable)THEN BEGIN
                    CLEAR(GenJournalLine);
                    GenJournalLine.INIT;
                    GenJournalLine.VALIDATE("Journal Template Name", 'GENERAL');
                    GenJournalLine.VALIDATE("Journal Batch Name", 'HR');
                    GenJournalLine.VALIDATE("Line No.", LastLineNo + 10000);
                    GenJournalLine.VALIDATE("GSSHR Integration Entry", TRUE);
                    //ITOS1.1-
                    //GenJournalLine.VALIDATE("Posting Date", GetPostingDate(HRStagingTable.PERIOD_DATE));
                    GenJournalLine.VALIDATE("Posting Date", HRStagingTable.BATCH_DATE);
                    //ITOS1.1+
                    GenJournalLine.VALIDATE("Document No.", HRStagingTable.BATCH_NUMBER);
                    GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::"G/L Account");
                    GenJournalLine.VALIDATE("Account No.", GetAccNo(HRStagingTable.GL_CODE));
                    IF GLSetup."GSSDefault Global Dim. 1 Value" <> '' THEN GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", GLSetup."GSSDefault Global Dim. 1 Value");
                    GenJournalLine.VALIDATE(Description, HRStagingTable.JOURNAL_NAME);
                    GenJournalLine.VALIDATE("Currency Code", GetCurrencyCode(HRStagingTable.CURRENCY));
                    IF HRStagingTable.AMOUNT_DR <> 0 THEN GenJournalLine.VALIDATE("Debit Amount", HRStagingTable.AMOUNT_DR);
                    IF HRStagingTable.AMOUNT_CR <> 0 THEN GenJournalLine.VALIDATE("Credit Amount", HRStagingTable.AMOUNT_CR);
                    GenJournalLine.INSERT(TRUE);
                    LastLineNo:=LastLineNo + 10000;
                    //ITOS1.1-
                    HRStagingTable.PROCESS_FLAG:='P';
                    //ITOS1.1+
                    HRStagingTable.NAV_PROCESSED:=TRUE;
                    HRStagingTable.NAV_PROCESSED_DATE:=TODAY;
                    HRStagingTable.NAV_PROCESSED_TIME:=TIME;
                    HRStagingTable.MODIFY(TRUE);
                END;
            UNTIL HRStagingTable.NEXT = 0;
    end;
    local procedure GetAccNo(AccCode: Code[20]): Code[20]var
        AccountNo: Code[20];
    begin
        CLEAR(AccountNo);
        IF STRPOS(AccCode, '-') = 0 THEN EXIT(AccCode);
        AccountNo:=COPYSTR(AccCode, STRPOS(AccCode, '-') + 1);
        EXIT(AccountNo);
    end;
    LOCAL procedure GetCurrencyCode(CurrName: Text[50]): Code[10]var
        CurrRec: Record Currency;
    begin
        CLEAR(CurrRec);
        CurrRec.SETCURRENTKEY(Code);
        CurrRec.SETRANGE(Description, CurrName);
        IF CurrRec.FINDFIRST THEN EXIT(CurrRec.Code);
        EXIT('');
    end;
    LOCAL procedure GetPostingDate(Period: Text): Date begin
        EXIT(CALCDATE('CM', DMY2DATE(1, GetMonth(Period), GetYear(Period))));
    end;
    LOCAL procedure GetMonth(Period: Text): Integer var
        Month: Text;
    begin
        CLEAR(Month);
        Month:=COPYSTR(Period, 1, 3);
        CASE UPPERCASE(Month)OF M_JAN: EXIT(1);
        M_FEB: EXIT(2);
        M_MAR: EXIT(3);
        M_APR: EXIT(4);
        M_MAY: EXIT(5);
        M_JUN: EXIT(6);
        M_JUL: EXIT(7);
        M_AUG: EXIT(8);
        M_SEP: EXIT(9);
        M_OCT: EXIT(10);
        M_NOV: EXIT(11);
        M_DEC: EXIT(12);
        ELSE
            ERROR('Invalid period');
        END;
    end;
    LOCAL procedure GetYear(Period: Text): Integer var
        Month: Integer;
    begin
        CLEAR(Month);
        EVALUATE(Month, '20' + COPYSTR(Period, 5, 2));
        EXIT(Month);
    end;
    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnAfterCopyGLEntryFromGenJnlLine', '', false, false)]
    local procedure CopyHREntryDetailsToGLEntry(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GLEntry."GSSHR Integration Entry":=GenJournalLine."GSSHR Integration Entry";
    end;
    procedure IsLineValid(HRStagingTable: Record "GSSHR Staging"): Boolean var
        HRStagingTable2: Record "GSSHR Staging";
        Skip: Boolean;
    begin
        IF NOT HRStagingTable2.GET(HRStagingTable.LINE_NUM)THEN EXIT;
        CLEAR(Skip);
        Skip:=FALSE;
        CLEAR(GLAccount);
        IF(NOT Skip) AND (NOT HRStagingTable2.NAV_ERROR) AND (HRStagingTable2.AMOUNT_DR = 0) AND (HRStagingTable2.AMOUNT_CR = 0)THEN BEGIN
            HRStagingTable2.NAV_SKIPPED:=TRUE;
            HRStagingTable2.NAV_ERR_MESSAGE:=STRSUBSTNO('Debit and Credit both have 0 value');
            Skip:=TRUE;
        END;
        IF(NOT Skip) AND (NOT HRStagingTable2.NAV_ERROR) AND (NOT GLAccount.GET(GetAccNo(HRStagingTable2.GL_CODE)))THEN BEGIN
            HRStagingTable2.NAV_ERROR:=TRUE;
            HRStagingTable2.NAV_ERR_MESSAGE:=STRSUBSTNO('Invalid G/L Code: %1', GetAccNo(HRStagingTable2.GL_CODE));
        END;
        IF(NOT Skip) AND (NOT HRStagingTable2.NAV_ERROR) AND (GetCurrencyCode(HRStagingTable2.CURRENCY) = '')THEN BEGIN
            HRStagingTable2.NAV_ERROR:=TRUE;
            HRStagingTable2.NAV_ERR_MESSAGE:=STRSUBSTNO('Invalid currency %1', HRStagingTable2.CURRENCY);
        END;
        IF Skip OR HRStagingTable2.NAV_ERROR THEN BEGIN
            HRStagingTable2.MODIFY(TRUE);
            EXIT(FALSE);
        END
        ELSE
            EXIT(TRUE);
    end;
    var HRStagingTable: Record "GSSHR Staging";
    GenJournalLine: Record "Gen. Journal Line";
    LastLineNo: Integer;
    GLAccount: Record "G/L Account";
    GLSetup: Record "General Ledger Setup";
    //Text Constants
    M_JAN: TextConst ENU = 'JAN';
    M_FEB: TextConst ENU = 'FEB';
    M_MAR: TextConst ENU = 'MAR';
    M_APR: TextConst ENU = 'APR';
    M_MAY: TextConst ENU = 'MAY';
    M_JUN: TextConst ENU = 'JUN';
    M_JUL: TextConst ENU = 'JUL';
    M_AUG: TextConst ENU = 'AUG';
    M_SEP: TextConst ENU = 'SEP';
    M_OCT: TextConst ENU = 'OCT';
    M_NOV: TextConst ENU = 'NOV';
    M_DEC: TextConst ENU = 'DEC';
    Text0001: TextConst ENU = 'Batch %1 cannot be processed. Please check entries for errors.';
}

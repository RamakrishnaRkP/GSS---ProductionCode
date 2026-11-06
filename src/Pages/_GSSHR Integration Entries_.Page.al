page 60101 "GSSHR Integration Entries"
{
    ApplicationArea = All;
    Caption = 'HR Integration Entries';
    PageType = List;
    SourceTable = "GSSHR Staging";
    SourceTableView = sorting(LINE_NUM)order(ascending)where(NAV_PROCESSED=const(false));
    UsageCategory = Lists;
    InsertAllowed = true;
    ModifyAllowed = false;
    DeleteAllowed = true;
    Editable = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(NAV_PROCESSED; Rec.NAV_PROCESSED)
                {
                    ApplicationArea = All;
                }
                field(NAV_ERROR; Rec.NAV_ERROR)
                {
                    ApplicationArea = All;
                }
                field(NAV_SKIPPED; Rec.NAV_SKIPPED)
                {
                    ApplicationArea = All;
                }
                field(NAV_ERR_MESSAGE; Rec.NAV_ERR_MESSAGE)
                {
                    ApplicationArea = All;
                }
                field(LINE_NUM; Rec.LINE_NUM)
                {
                    ApplicationArea = All;
                }
                field(JOURNAL_NAME; Rec.JOURNAL_NAME)
                {
                    ApplicationArea = All;
                }
                field(LEDGER_NAME; Rec.LEDGER_NAME)
                {
                    ApplicationArea = All;
                }
                field(PERIOD_DATE; Rec.PERIOD_DATE)
                {
                    ApplicationArea = All;
                }
                field(GL_CODE; Rec.GL_CODE)
                {
                    ApplicationArea = All;
                }
                field(AMOUNT_DR; Rec.AMOUNT_DR)
                {
                    ApplicationArea = All;
                }
                field(AMOUNT_CR; Rec.AMOUNT_CR)
                {
                    ApplicationArea = All;
                }
                field(DESCRIPTION; Rec.DESCRIPTION)
                {
                    ApplicationArea = All;
                }
                field(PROCESS_FLAG; Rec.PROCESS_FLAG)
                {
                    ApplicationArea = All;
                }
                field(ERR_MSG; Rec.ERR_MSG)
                {
                    ApplicationArea = All;
                }
                field(BATCH_NUMBER; Rec.BATCH_NUMBER)
                {
                    ApplicationArea = All;
                }
                field(BATCH_DATE; Rec.BATCH_DATE)
                {
                    ApplicationArea = All;
                }
                field(HR_USER; Rec.HR_USER)
                {
                    ApplicationArea = All;
                }
                field(CURRENCY; Rec.CURRENCY)
                {
                    ApplicationArea = All;
                }
                field(PROCESS_DATE; Rec.PROCESS_DATE)
                {
                    ApplicationArea = All;
                }
                field(PROCESS_TIME; Rec.PROCESS_TIME)
                {
                    ApplicationArea = All;
                }
                field(NAV_PROCESSED_DATE; Rec.NAV_PROCESSED_DATE)
                {
                    ApplicationArea = All;
                }
                field(NAV_PROCESSED_TIME; Rec.NAV_PROCESSED_TIME)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(GSSProcessEntries)
            {
                Caption = 'Process Entries';
                ApplicationArea = All;
                Image = CreateLinesFromJob;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    HRStagingUpdate: Codeunit "GSSHR Staging Update";
                    HRStagingTable: Record "GSSHR Staging";
                    HRStagingTable2: Record "GSSHR Staging";
                begin
                    HRStagingTable.SETCURRENTKEY(LINE_NUM);
                    HRStagingTable.SETRANGE(BATCH_NUMBER, Rec.BATCH_NUMBER);
                    IF NOT HRStagingTable.FINDFIRST THEN ERROR('No records found.');
                    HRStagingTable2.COPYFILTERS(HRStagingTable);
                    IF HRStagingTable2.FINDFIRST THEN REPEAT IF NOT HRStagingTable2.NAV_ERROR THEN HRStagingUpdate.IsLineValid(HRStagingTable2);
                        UNTIL HRStagingTable2.NEXT = 0;
                    //commiting so that nav error flag & error message is committed.
                    COMMIT;
                    CLEAR(HRStagingTable2);
                    HRStagingTable2.SETCURRENTKEY(LINE_NUM);
                    HRStagingTable2.SETRANGE(BATCH_NUMBER, Rec.BATCH_NUMBER);
                    HRStagingTable2.SETRANGE(NAV_ERROR, TRUE);
                    IF HRStagingTable2.FINDFIRST THEN ERROR(Text0001, HRStagingTable2.BATCH_NUMBER);
                    CLEAR(HRStagingTable);
                    HRStagingTable.SETCURRENTKEY(LINE_NUM);
                    HRStagingTable.SETRANGE(BATCH_NUMBER, Rec.BATCH_NUMBER);
                    HRStagingTable.SETRANGE(NAV_SKIPPED, FALSE);
                    IF HRStagingTable.FINDFIRST THEN;
                    HRStagingUpdate.RUN(HRStagingTable);
                end;
            }
        }
    }
    var Text0001: TextConst ENU = 'Batch %1 cannot be processed. Check the entries for errors.';
}

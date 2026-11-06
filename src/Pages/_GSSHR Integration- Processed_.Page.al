page 60100 "GSSHR Integration- Processed"
{
    ApplicationArea = All;
    Caption = 'HR Integration- Processed';
    PageType = List;
    SourceTable = "GSSHR Staging";
    SourceTableView = sorting(LINE_NUM)order(ascending)where(NAV_PROCESSED=const(true));
    UsageCategory = Lists;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Editable = false;

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
}

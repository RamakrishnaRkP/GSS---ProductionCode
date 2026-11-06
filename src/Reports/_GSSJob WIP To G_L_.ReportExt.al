reportextension 60101 "GSSJob WIP To G/L" extends "Job WIP To G/L"
{
    dataset
    {
        modify(Job)
        {
        trigger OnBeforeAfterGetRecord()
        var
            myInt: Integer;
        begin
            Job.TestField(GSSStatus, Job.GSSStatus::Released);
        end;
        }
    }
}

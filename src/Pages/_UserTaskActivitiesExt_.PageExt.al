pageextension 60195 "UserTaskActivitiesExt" extends "User Tasks Activities"
{
    layout
    {
        modify("UserTaskManagement.GetMyPendingUserTasksCount")
        {
            Visible = false;
        }
    }
}

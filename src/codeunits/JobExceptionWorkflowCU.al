// codeunit 60115 GSSExceptionApprovalMgt
// {

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', false, false)]
//     local procedure ApprovalsMgmtOnApproveApprovalRequest(var ApprovalEntry: Record "Approval Entry")
//     var
//         Job: Record Job;
//         RecordId: RecordId;
//     begin
//         if ApprovalEntry."Table ID" <> Database::Job then
//             exit;

//         RecordId := ApprovalEntry."Record ID to Approve";
//         if RecordId.TableNo() <> Database::Job then
//             exit;

//         if not Job.Get(RecordId) then
//             exit;

//         if Job."Need Exception Approval" then
//             exit;

//         CheckAndSetNeedExceptionApproval(Job);
//     end;

//     local procedure CheckAndSetNeedExceptionApproval(var Job: Record Job)
//     var
//         ApprovalEntry: Record "Approval Entry";
//         HasApprovedApproval: Boolean;
//     begin
//         if Job."Need Exception Approval" then
//             exit;

//         ApprovalEntry.Reset();
//         ApprovalEntry.SetRange("Table ID", Database::Job);
//         ApprovalEntry.SetRange("Record ID to Approve", Job.RecordId);
//         ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
//         HasApprovedApproval := not ApprovalEntry.IsEmpty();

//         if not HasApprovedApproval then
//             exit;

//         ApprovalEntry.Reset();
//         ApprovalEntry.SetRange("Table ID", Database::Job);
//         ApprovalEntry.SetRange("Record ID to Approve", Job.RecordId);
//         ApprovalEntry.SetFilter(
//             Status,
//             '<>%1&<>%2',
//             ApprovalEntry.Status::Approved,
//             ApprovalEntry.Status::Canceled);

//         if not ApprovalEntry.IsEmpty() then
//             exit;

//         Job."Need Exception Approval" := true;
//         Job.Modify(true);
//     end;

//     // ============================================================
//     // PHASE 2: sending the Exception approval request
//     // ============================================================
//     procedure IsExceptionApprovalWorkflowEnabled(var Job: Record Job): Boolean
//     begin
//         exit(WorkflowManagement.CanExecuteWorkflow(Job, RunWorkflowOnSendExceptionForApprovalCode()));
//     end;

//     procedure CheckSendExceptionApprovalPossible(var Job: Record Job): Boolean
//     begin
//         if not IsExceptionApprovalWorkflowEnabled(Job) then
//             Error(NoWorkflowEnabledErr);

//         if not Job."Need Exception Approval" then
//             Error(NotNeededErr);

//         if Job.GSSStatus <> Job.GSSStatus::Released then
//             Error(JobMustBeReleasedErr);

//         if Job."Delivery Exception allowed" and Job."Invoice Exception allowed" then
//             Error(AlreadyAllowedErr);

//         OnAfterCheckSendExceptionApprovalPossible(Job);
//         exit(true);
//     end;

//     procedure SendExceptionForApproval(var Job: Record Job)
//     begin
//         CheckSendExceptionApprovalPossible(Job);
//         OnSendExceptionForApproval(Job);
//     end;

//     procedure CancelExceptionApprovalRequest(var Job: Record Job)
//     begin
//         OnCancelExceptionApprovalRequest(Job);
//     end;

//     procedure RunWorkflowOnSendExceptionForApprovalCode(): Code[128]
//     begin
//         exit(UpperCase('RunWorkflowOnSendExceptionForApproval'));
//     end;

//     procedure RunWorkflowOnCancelExceptionApprovalRequestCode(): Code[128]
//     begin
//         exit(UpperCase('RunWorkflowOnCancelExceptionApprovalRequest'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::GSSExceptionApprovalMgt, 'OnSendExceptionForApproval', '', false, false)]
//     local procedure RunWorkflowOnSendException(var Job: Record Job)
//     begin
//         WorkflowManagement.HandleEvent(RunWorkflowOnSendExceptionForApprovalCode(), Job);
//     end;

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::GSSExceptionApprovalMgt, 'OnCancelExceptionApprovalRequest', '', false, false)]
//     local procedure RunWorkflowOnCancelException(var Job: Record Job)
//     begin
//         WorkflowManagement.HandleEvent(RunWorkflowOnCancelExceptionApprovalRequestCode(), Job);
//     end;


//     // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', false, false)]
//     // local procedure OnApproveExceptionApprovalRequest(var ApprovalEntry: Record "Approval Entry")
//     // var
//     //     Job: Record Job;
//     //     RecRef: RecordRef;
//     // begin
//     //     if ApprovalEntry."Table ID" <> Database::Job then
//     //         exit;

//     //     RecRef.Get(ApprovalEntry."Record ID to Approve");
//     //     RecRef.SetTable(Job);

//     //     if Job.GSSStatus <> Job.GSSStatus::Released then
//     //         exit;

//     //     if not Job."Need Exception Approval" then
//     //         exit;

//     //     if Job."Delivery Exception allowed" and Job."Invoice Exception allowed" then
//     //         exit; // already done - avoid re-processing

//     //     Job."Delivery Exception allowed" := true;
//     //     Job."Delivery Exc. allowed by User" := ApprovalEntry."Approver ID";

//     //     Job."Invoice Exception allowed" := true;
//     //     Job."Invoice Exc. allowed by User" := ApprovalEntry."Approver ID";

//     //     Job.Modify(true);
//     // end;

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
//     local procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
//     var
//         Job: Record Job;
//         JobDocClass: Codeunit "GSSJob Document Class";
//     begin
//         case RecRef.Number of
//             Database::Job:
//                 begin
//                     RecRef.SetTable(Job);
//                     if Job.GSSStatus <> Job.GSSStatus::Released then
//                         exit;

//                     if not Job."Need Exception Approval" then
//                         exit;

//                     if Job."Delivery Exception allowed" and Job."Invoice Exception allowed" then
//                         exit; // already done - avoid re-processing

//                     Job.validate("Delivery Exception allowed", true);
//                     Job.validate("Invoice Exception allowed", true);

//                     Job.Modify(true);
//                     Handled := true;
//                 end;
//         end;
//     end;

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', false, false)]
//     local procedure OnRejectExceptionApprovalRequest(var ApprovalEntry: Record "Approval Entry")
//     var
//         Job: Record Job;
//         RecRef: RecordRef;
//     begin
//         if ApprovalEntry."Table ID" <> Database::Job then
//             exit;

//         RecRef.Get(ApprovalEntry."Record ID to Approve");
//         RecRef.SetTable(Job);

//         if Job.GSSStatus <> Job.GSSStatus::Released then
//             exit;


//     end;


//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
//     local procedure GSSOnAddWorkflowEventsToLibrary()
//     var
//         WorkflowEventHandling: Codeunit "Workflow Event Handling";
//     begin
//         WorkflowEventHandling.AddEventToLibrary(
//             RunWorkflowOnSendExceptionForApprovalCode(), Database::Job,
//             ExceptionSendForApprovalDescTxt, 0, false);

//         WorkflowEventHandling.AddEventToLibrary(
//             RunWorkflowOnCancelExceptionApprovalRequestCode(), Database::Job,
//             ExceptionCancelApprovalDescTxt, 0, false);
//     end;

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', false, false)]
//     local procedure GSSOnAddWorkflowEventPredecessorsToLibrary(EventFunctionName: Code[128])
//     var
//         WorkflowEventHandling: Codeunit "Workflow Event Handling";
//         GSSApprovalMgt: Codeunit GSSApprovalMgt;
//     begin
//         case EventFunctionName of
//             RunWorkflowOnSendExceptionForApprovalCode():
//                 WorkflowEventHandling.AddEventPredecessor(
//                     RunWorkflowOnSendExceptionForApprovalCode(),
//                     GSSApprovalMgt.RunWorkflowOnAfterReleaseJobDocCode());

//             RunWorkflowOnCancelExceptionApprovalRequestCode():
//                 WorkflowEventHandling.AddEventPredecessor(
//                     RunWorkflowOnCancelExceptionApprovalRequestCode(),
//                     RunWorkflowOnSendExceptionForApprovalCode());

//             WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode():
//                 WorkflowEventHandling.AddEventPredecessor(
//                     WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode(),
//                     RunWorkflowOnSendExceptionForApprovalCode());

//             WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode():
//                 WorkflowEventHandling.AddEventPredecessor(
//                     WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode(),
//                     RunWorkflowOnSendExceptionForApprovalCode());
//         end;
//     end;

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowTableRelationsToLibrary', '', false, false)]
//     local procedure GSSOnAddWorkflowTableRelationsToLibrary()
//     var
//         ApprovalEntry: Record "Approval Entry";
//         WorkflowSetup: Codeunit "Workflow Setup";
//     begin
//         WorkflowSetup.InsertTableRelation(Database::Job, 1, Database::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', false, false)]
//     local procedure GSSOnAddWorkflowResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])
//     var
//         WorkflowResponseHandling: Codeunit "Workflow Response Handling";
//     begin
//         case ResponseFunctionName of
//             WorkflowResponseHandling.CreateApprovalRequestsCode():
//                 WorkflowResponseHandling.AddResponsePredecessor(
//                     WorkflowResponseHandling.CreateApprovalRequestsCode(),
//                     RunWorkflowOnSendExceptionForApprovalCode());

//             WorkflowResponseHandling.SendApprovalRequestForApprovalCode():
//                 WorkflowResponseHandling.AddResponsePredecessor(
//                     WorkflowResponseHandling.SendApprovalRequestForApprovalCode(),
//                     RunWorkflowOnSendExceptionForApprovalCode());

//             WorkflowResponseHandling.CancelAllApprovalRequestsCode():
//                 WorkflowResponseHandling.AddResponsePredecessor(
//                     WorkflowResponseHandling.CancelAllApprovalRequestsCode(),
//                     RunWorkflowOnCancelExceptionApprovalRequestCode());
//         end;
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure OnAfterCheckSendExceptionApprovalPossible(var Job: Record Job)
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     procedure OnSendExceptionForApproval(var Job: Record Job)
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     procedure OnCancelExceptionApprovalRequest(var Job: Record Job)
//     begin
//     end;

//     var
//         WorkflowManagement: Codeunit "Workflow Management";
//         NoWorkflowEnabledErr: Label 'No approval workflow for Delivery/Invoice Exception is enabled.';
//         NotNeededErr: Label 'This job does not require Exception Approval. Turn on "Need Exception Approval" first.';
//         JobMustBeReleasedErr: Label 'You can only request Exception Approval after the Job is fully approved and Released.';
//         AlreadyAllowedErr: Label 'Delivery and Invoice Exception are already allowed for this job.';
//         ExceptionSendForApprovalDescTxt: TextConst ENU = 'Approval of Delivery/Invoice Exception is requested.';
//         ExceptionCancelApprovalDescTxt: TextConst ENU = 'An approval request for Delivery/Invoice Exception is canceled.';
// }
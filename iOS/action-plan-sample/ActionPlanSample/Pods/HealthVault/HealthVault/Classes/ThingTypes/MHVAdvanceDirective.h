//
// MHVAdvanceDirective.h
// MHVLib
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


#import <Foundation/Foundation.h>
#import "MHVTypes.h"

@interface MHVAdvanceDirective : MHVThingDataTyped

// -------------------------
//
// Data
//
// -------------------------
//
// (Required) The date and time of when the directive started.
//
@property (readwrite, nonatomic, strong) MHVApproxDateTime *startDate;
//
// (Required) The date and time of when the directive stops.
//
@property (readwrite, nonatomic, strong) MHVApproxDateTime *stopDate;
//
// (Optional) Display information about this directive
// This should be a short set of information like DNR (Do not resuscitate).
// More verbose information should go into the common/note section of the thing.
//
@property (readwrite, nonatomic, strong) NSString *descriptionText;
//
// (Optional) The full resuscitation directive value.
// True for full resuscitation.
//
@property (readwrite, nonatomic, strong) MHVBool *fullResuscitation;
//
// (Optional) The list of prohibited interventions in this directive.
//
@property (readwrite, nonatomic, strong) MHVCodableValue *prohibitedInterventions;
//
// (Optional) Additional directive instructions
// This provides a free form type for additional directive instructions
//
@property (readwrite, nonatomic, strong) NSString *additionalInstructions;
//
// (Optional) The attending physician details.
//
@property (readwrite, nonatomic, strong) MHVPerson *attendingPhysician;
//
// (Optional) The attending physician endorsement date and time
//
@property (readwrite, nonatomic, strong) MHVDateTime *attendingPhysicianEndorsement;
//
// (Optional) The attending nurse details
//
@property (readwrite, nonatomic, strong) MHVPerson *attendingNurse;
//
// (Optional) The attending nurse endorsement details
//
@property (readwrite, nonatomic, strong) MHVDateTime *attendingNurseEndorsement;
//
// (Optional) The date and time of patient expired.
//
@property (readwrite, nonatomic, strong) MHVDateTime *expirationDate;
//
// (Optional) The date and time clinical support was discontinued.
//
@property (readwrite, nonatomic, strong) MHVApproxDateTime *discontinuationDate;
//
// (Optional) The attending physician details.
//
@property (readwrite, nonatomic, strong) MHVPerson *discontinuationPhysician;
//
// (Optional) The attending physician discontinuation endorsement date and time.
//
@property (readwrite, nonatomic, strong) MHVDateTime *discontinuationPhysicianEndorsement;
//
// (Optional) The attending nurse details
//
@property (readwrite, nonatomic, strong) MHVPerson *discontinuationNurse;
//
// (Optional) The attending nurse discontinuation endorsement date and time.
//
@property (readwrite, nonatomic, strong) MHVDateTime *discontinuationNurseEndorsement;

@end

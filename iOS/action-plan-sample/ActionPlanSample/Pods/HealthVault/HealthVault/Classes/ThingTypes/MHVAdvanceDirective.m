//
// MHVAdvanceDirective.m
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


#import "MHVAdvanceDirective.h"

static NSString *const c_typeid = @"822a5e5a-14f1-4d06-b92f-8f3f1b05218f";
static NSString *const c_typename = @"directive";

static NSString *const c_element_start_date = @"start-date";
static NSString *const c_element_stop_date = @"stop-date";
static NSString *const c_element_description = @"description";
static NSString *const c_element_full_resuscitation = @"full-resuscitation";
static NSString *const c_element_prohibited_interventions = @"prohibited-interventions";
static NSString *const c_element_additional_instructions = @"additional-instructions";
static NSString *const c_element_attending_physician = @"attending-physician";
static NSString *const c_element_attending_physician_endorsement = @"attending-physician-endorsement";
static NSString *const c_element_attending_nurse = @"attending-nurse";
static NSString *const c_element_attending_nurse_endorsement = @"attending-nurse-endorsement";
static NSString *const c_element_expiration_date = @"expiration-date";
static NSString *const c_element_discontinuation_date = @"discontinuation-date";
static NSString *const c_element_discontinuation_physician = @"discontinuation-physician";
static NSString *const c_element_discontinuation_physician_endorsement = @"discontinuation-physician-endorsement";
static NSString *const c_element_discontinuation_nurse = @"discontinuation-nurse";
static NSString *const c_element_discontinuation_nurse_endorsement = @"discontinuation-nurse-endorsement";

@implementation MHVAdvanceDirective

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_start_date content:self.startDate];
    [writer writeElement:c_element_stop_date content:self.stopDate];
    [writer writeElement:c_element_description value:self.descriptionText];
    [writer writeElement:c_element_full_resuscitation content:self.fullResuscitation];
    [writer writeElement:c_element_prohibited_interventions content:self.prohibitedInterventions];
    [writer writeElement:c_element_additional_instructions value:self.additionalInstructions];
    [writer writeElement:c_element_attending_physician content:self.attendingPhysician];
    [writer writeElement:c_element_attending_physician_endorsement content:self.attendingPhysicianEndorsement];
    [writer writeElement:c_element_attending_nurse content:self.attendingNurse];
    [writer writeElement:c_element_attending_nurse_endorsement content:self.attendingNurseEndorsement];
    [writer writeElement:c_element_expiration_date content:self.expirationDate];
    [writer writeElement:c_element_discontinuation_date content:self.discontinuationDate];
    [writer writeElement:c_element_discontinuation_physician content:self.discontinuationPhysician];
    [writer writeElement:c_element_discontinuation_physician_endorsement content:self.discontinuationPhysicianEndorsement];
    [writer writeElement:c_element_discontinuation_nurse content:self.discontinuationNurse];
    [writer writeElement:c_element_discontinuation_nurse_endorsement content:self.discontinuationNurseEndorsement];
}

- (void)deserialize:(XReader *)reader
{
    self.startDate = [reader readElement:c_element_start_date asClass:[MHVApproxDateTime class]];
    self.stopDate = [reader readElement:c_element_stop_date asClass:[MHVApproxDateTime class]];
    self.descriptionText = [reader readStringElement:c_element_description];
    self.fullResuscitation = [reader readElement:c_element_full_resuscitation asClass:[MHVBool class]];
    self.prohibitedInterventions = [reader readElement:c_element_prohibited_interventions asClass:[MHVCodedValue class]];
    self.additionalInstructions = [reader readStringElement:c_element_additional_instructions];
    self.attendingPhysician = [reader readElement:c_element_attending_physician asClass:[MHVPerson class]];
    self.attendingPhysicianEndorsement = [reader readElement:c_element_attending_physician_endorsement asClass:[MHVDateTime class]];
    self.attendingNurse = [reader readElement:c_element_attending_nurse asClass:[MHVPerson class]];
    self.attendingNurseEndorsement = [reader readElement:c_element_attending_nurse_endorsement asClass:[MHVDateTime class]];
    self.expirationDate = [reader readElement:c_element_expiration_date asClass:[MHVDateTime class]];
    self.discontinuationDate = [reader readElement:c_element_discontinuation_date asClass:[MHVApproxDateTime class]];
    self.discontinuationPhysician = [reader readElement:c_element_discontinuation_physician asClass:[MHVPerson class]];
    self.discontinuationPhysicianEndorsement = [reader readElement:c_element_discontinuation_physician_endorsement asClass:[MHVDateTime class]];
    self.discontinuationNurse = [reader readElement:c_element_discontinuation_nurse asClass:[MHVPerson class]];
    self.discontinuationNurseEndorsement = [reader readElement:c_element_discontinuation_nurse_endorsement asClass:[MHVDateTime class]];
}

+ (NSString *)typeID
{
    return c_typeid;
}

+ (NSString *)XRootElement
{
    return c_typename;
}

@end

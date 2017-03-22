////////////////////////////////////////////////////////////////////////////
//
// Copyright 2016 Realm Inc.
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
//
////////////////////////////////////////////////////////////////////////////

import Foundation
import SwiftyUserDefaults

struct Constants {
    static let headerHeight: Float = 30.0
    static let dateFormatString:String = "MMM yyyy HH:mm"
}

extension DefaultsKeys {
    static let userHasOnboarded = DefaultsKey<Bool>("user_has_onboarded")
    static let broker = DefaultsKey<String>("broker")
    static let strategy = DefaultsKey<String>("strategy")
}

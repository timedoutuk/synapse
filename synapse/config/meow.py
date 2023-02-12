# -*- coding: utf-8 -*-
# Copyright 2020 Maunium
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from ._base import Config


class MeowConfig(Config):
    """Meow Configuration
    Configuration for disabling dumb limits in Synapse
    """

    section = "meow"

    def read_config(self, config, **kwargs):
        meow_config = config.get("meow", {})
        self.validation_override = set(meow_config.get("validation_override", []))
        self.filter_override = set(meow_config.get("filter_override", []))
        self.timestamp_override = set(meow_config.get("timestamp_override", []))
        self.admin_api_register_invalid = meow_config.get(
            "admin_api_register_invalid", True
        )

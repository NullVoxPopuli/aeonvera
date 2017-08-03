# frozen_string_literal: true

require 'drawers'

Drawers.resource_suffixes = [*Drawers::DEFAULT_RESOURCE_SUFFIXES,
                             'SerializableResource',
                             'Presenter',
                             'Fields']

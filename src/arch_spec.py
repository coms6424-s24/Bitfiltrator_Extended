# author: Sahand Kashani <sahand.kashani@epfl.ch>

import abc

import helpers
import resources
from arch_names import ArchName


#Changed static methods to return values from 7 series, and added a 7 series archspec based on its FAR from UG470

# Abstract architecture.
class ArchSpec(abc.ABC):
  @abc.abstractmethod
  def far_reserved_idx_high(self) -> int:
    raise NotImplementedError

  @abc.abstractmethod
  def far_reserved_idx_low(self) -> int:
    raise NotImplementedError

  def far_reserved_width(self) -> int:
    return helpers.width(self.far_reserved_idx_high(), self.far_reserved_idx_low())

  @abc.abstractmethod
  def far_block_type_idx_high(self) -> int:
    raise NotImplementedError

  @abc.abstractmethod
  def far_block_type_idx_low(self) -> int:
    raise NotImplementedError

  def far_block_type_width(self) -> int:
    return helpers.width(self.far_block_type_idx_high(), self.far_block_type_idx_low())
  def far_half_bit_width(self) -> int:
    return helpers.width(self.far_half_bit_idx_high(), self.far_half_bit_idx_low())
  @abc.abstractmethod
  def far_half_bit_idx_high(self) -> int:
    raise NotImplementedError

  @abc.abstractmethod
  def far_half_bit_idx_low(self) -> int:
    raise NotImplementedError

  @abc.abstractmethod
  def far_row_address_idx_high(self) -> int:
    raise NotImplementedError

  @abc.abstractmethod
  def far_row_address_idx_low(self) -> int:
    raise NotImplementedError

  def far_row_address_width(self) -> int:
    return helpers.width(self.far_row_address_idx_high(), self.far_row_address_idx_low())

  @abc.abstractmethod
  def far_column_address_idx_high(self) -> int:
    raise NotImplementedError

  @abc.abstractmethod
  def far_column_address_idx_low(self) -> int:
    raise NotImplementedError

  def far_column_address_width(self) -> int:
    return helpers.width(self.far_column_address_idx_high(), self.far_column_address_idx_low())

  @abc.abstractmethod
  def far_minor_address_idx_high(self) -> int:
    return NotImplementedError

  @abc.abstractmethod
  def far_minor_address_idx_low(self) -> int:
    return NotImplementedError

  def far_minor_address_width(self) -> int:
    return helpers.width(self.far_minor_address_idx_high(), self.far_minor_address_idx_low())

  @abc.abstractmethod
  def frame_size_words(self) -> int:
    raise NotImplementedError

  @staticmethod
  def num_clb_per_column() -> int:
    # UG574: 7 series picture Architecture Configurable Logic Block (pg 11)
    return 50

  @staticmethod
  def num_lut_per_clb() -> int:
    # UG474: 7 series configurable logic block (pg 15)
    return 8

  @staticmethod
  def num_reg_per_clb() -> int:
    # UG474: 7 series Architecture Configurable Logic Block (pg 15)
    return 16

  @staticmethod
  def num_dsp_per_column() -> int:
    # UG474: 7 series picture
    return 20

  @staticmethod
  def num_36k_bram_per_column() -> int:
    # UG474: 7 series picture
    return 10

  @staticmethod
  def num_18k_bram_per_column() -> int:
    # UG474: 7 series picture
    return 20

  # Factory method to create a spec.
  #
  # Don't know how to add circular type hint to THIS class, so I omit return type.
  # Returns a UltraScaleSpec or UltraScalePlusSpec.
  @staticmethod
  def create_spec(part: str):
    (device, arch) = resources.get_device_and_arch(part)

    supported_archs = {ArchName.ULTRASCALE, ArchName.ULTRASCALE_PLUS, ArchName.Seven_SeriesSpec }
    assert arch in supported_archs, f"Error: Unknown architecture {arch}"

    return Seven_SeriesSpec()
    #if arch == ArchName.ULTRASCALE_PLUS:
    #  return UltraScalePlusSpec()
    #else:
    #  return UltraScaleSpec()

  def __hash__(self) -> int:
    return hash((
      self.__class__,
      self.far_reserved_idx_high(),
      self.far_reserved_idx_low(),
      self.far_block_type_idx_high(),
      self.far_block_type_idx_low(),
      self.far_half_bit_idx_high(),
      self.far_half_bit_idx_low(),
      self.far_row_address_idx_high(),
      self.far_row_address_idx_low(),
      self.far_column_address_idx_high(),
      self.far_column_address_idx_low(),
      self.far_minor_address_idx_high(),
      self.far_minor_address_idx_low(),
      self.frame_size_words(),
      self.num_clb_per_column(),
      self.num_lut_per_clb(),
      self.num_reg_per_clb(),
      self.num_dsp_per_column(),
      self.num_36k_bram_per_column(),
      self.num_18k_bram_per_column()
    ))

# Concrete architecture.
class UltraScaleSpec(ArchSpec):
  # FAR register: UG570 table 9-21
  def far_reserved_idx_high(self) -> int: return 31
  def far_reserved_idx_low(self) -> int: return 26
  def far_block_type_idx_high(self) -> int: return 25
  def far_block_type_idx_low(self) -> int: return 23
  def far_row_address_idx_high(self) -> int: return 22
  def far_row_address_idx_low(self) -> int: return 17
  def far_column_address_idx_high(self) -> int: return 16
  def far_column_address_idx_low(self) -> int: return 7
  def far_minor_address_idx_high(self) -> int: return 6
  def far_minor_address_idx_low(self) -> int: return 0
  def frame_size_words(self) -> int: return 123

# Concrete architecture.
class UltraScalePlusSpec(ArchSpec):
  # FAR register: UG570 table 9-21
  def far_reserved_idx_high(self) -> int: return 31
  def far_reserved_idx_low(self) -> int: return 27
  def far_block_type_idx_high(self) -> int: return 26
  def far_block_type_idx_low(self) -> int: return 24
  def far_row_address_idx_high(self) -> int: return 23
  def far_row_address_idx_low(self) -> int: return 18
  def far_column_address_idx_high(self) -> int: return 17
  def far_column_address_idx_low(self) -> int: return 8
  def far_minor_address_idx_high(self) -> int: return 7
  def far_minor_address_idx_low(self) -> int: return 0
  def frame_size_words(self) -> int: return 93


class Seven_SeriesSpec(ArchSpec):
  # FAR register: UG470 table 5-24
  def far_reserved_idx_high(self) -> int: return 31
  def far_reserved_idx_low(self) -> int: return 26
  def far_block_type_idx_high(self) -> int: return 25
  def far_block_type_idx_low(self) -> int: return 23
  def far_half_bit_idx_high(self) -> int: return 22
  def far_half_bit_idx_low(self) -> int: return 22
  def far_row_address_idx_high(self) -> int: return 21
  def far_row_address_idx_low(self) -> int: return 17
  def far_column_address_idx_high(self) -> int: return 16
  def far_column_address_idx_low(self) -> int: return 7
  def far_minor_address_idx_high(self) -> int: return 6
  def far_minor_address_idx_low(self) -> int: return 0
  def frame_size_words(self) -> int: return 101

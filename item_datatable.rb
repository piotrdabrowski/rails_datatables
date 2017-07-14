class ItemDatatable < ApplicationDatatable
  delegate :edit_item_path, to: :@view
  delegate :number_to_currency, to: :@view

  private

  def data
    items.map do |ride|
      data = {}
      columns.each do |column|
        data[column] = case column.to_sym
        when :created_at; item.created_at.strftime('%Y-%m-%d %H:%M')
        else
          item.send(column)
        end
      end
      data
    end
  end

  def count
    Item.count
  end

  def total_entries
    items.count
  end

  def items
    @items ||= fetch_items
  end

  def fetch_items
    Ride.order("#{columns[sort_column]} #{sort_direction}").page(page).per_page(per_page)
  end

  def columns
    %w(created_at)
  end
end

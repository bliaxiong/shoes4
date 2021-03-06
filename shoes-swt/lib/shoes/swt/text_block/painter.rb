class Shoes
  module Swt
    class TextBlock
      class Painter
        include ::Swt::Events::PaintListener
        include Common::Resource

        attr_reader :app
        def initialize(dsl)
          @dsl = dsl
          @style = @dsl.style
          @app = @dsl.app.gui
        end

        def paintControl(paint_event)
          reset_graphics_context(paint_event.gc)
          return if @dsl.hidden?
          # See #636 for discussion, contents_alignment may not run or if the
          # space is very narrow we might squish things down to be very narrow.
          # If paint is triggered then, code later on will crash.
          return if @dsl.gui.segments.empty?

          draw_layouts(paint_event.gc)
        end

        def draw_layouts(graphic_context)
          layouts = TextSegmentCollection.new(@dsl,
                                              @dsl.gui.segments,
                                              default_text_styles)
          layouts.paint_control(graphic_context)
        end

        private

        def default_text_styles
          {
            fg: @style[:fg],
            bg: @style[:bg],
            strikecolor: @style[:strikecolor],
            undercolor: @style[:undercolor],
            font_detail: {
              name: @dsl.font,
              size: @dsl.size,
              styles: [::Swt::SWT::NORMAL]
            }
          }
        end
      end
    end
  end
end

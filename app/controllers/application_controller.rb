class ApplicationController < ActionController::API
     require "json"
     # before_action :authenticate_customer!
     before_action :set_params
     # # NoMethodError: undefined method `respond_to' のエラー対策
     # include ActionController::MimeResponds
     include DeviseTokenAuth::Concerns::SetUserByToken

     def set_params
          #セッション時間を決める
          @start_time = [8,30]
          @finish_time = [22,10]
          @training_time = 40
          @break_time = 20
          @one_lesson_length = @training_time + @break_time
      end

      def make_time_schedule_in_one_day(year, month, day)
          start_time = Time.new(year, month, day, @start_time[0],@start_time[1])
          limit = Time.new(year, month, day, @finish_time[0], @finish_time[1])
          @times = [[start_time, start_time + @one_lesson_length*60]]
          # while(start_time <= limit) do
          while(start_time + 60*(@training_time+@break_time) <= limit) do
            start_time = start_time + @one_lesson_length*60
              @times << [start_time, start_time + @training_time*60]
          end
          
          return @times
      end
      
     # def info_check 
     #      if v1_customer_signed_in?
     #      elsif v1_trainer_signed_in?
     #      end
     # end
end

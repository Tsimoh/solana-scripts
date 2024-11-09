#!/bin/bash

# Функция для проверки и смены режима CPU Scaling Governor на performance
check_and_switch_to_performance() {
    for attempt in 1 2 3; do
        current_governor=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
        
        if [ "$current_governor" != "performance" ]; then
            echo "Текущий режим CPU Scaling Governor: $current_governor"
            echo "Попытка $attempt: Переключение в режим performance..."
            echo "performance" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor > /dev/null
            updated_governor=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
            
            if [ "$updated_governor" == "performance" ]; then
                echo "Режим CPU Scaling Governor успешно изменен на performance."
                return
            else
                echo "Ошибка: Не удалось переключиться в режим performance."
            fi
        else
            echo "Режим CPU Scaling Governor уже установлен на performance."
            return
        fi
    done
    echo ""    
    echo "Ошибка: Не удалось переключиться в режим performance после трех попыток."
    echo ""
    exit 1
}

check_and_switch_to_performance

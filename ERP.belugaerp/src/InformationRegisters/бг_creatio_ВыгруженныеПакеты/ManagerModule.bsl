
#Область ПрограммныйИнтерфейс

// Записывает информацию в регистр о выгруженном пакете
//
// Параметры:
//  ИдентификаторПакета - Строка;
//  НомерЗаписиВПакете - Число;
//  Период - Дата;
//  Отправлен - Булево;
//  Принят - Булево;
//
// Тип возвращаемого значения - Структура
//
Функция ЗарегистрироватьВыгрузкуПакета(ИдентификаторПакета, НомерЗаписиВПакете, Период, Отправлен, Принят) Экспорт
	
	Результат = Новый Структура("ЕстьОшибки, ОписаниеОшибки", Ложь, "");
	
	МенеджерЗаписиДанных = РегистрыСведений.бг_creatio_ВыгруженныеПакеты.СоздатьМенеджерЗаписи();
	МенеджерЗаписиДанных.Период = ?(Период = Неопределено, ТекущаяДатаСеанса(), Период);
	МенеджерЗаписиДанных.Отправлен = Отправлен;
	МенеджерЗаписиДанных.Принят = Принят;
	МенеджерЗаписиДанных.ИдентификаторПакета = ИдентификаторПакета;
	МенеджерЗаписиДанных.НомерЗаписиВПакете = НомерЗаписиВПакете;
		
	Попытка
		МенеджерЗаписиДанных.Записать();
	Исключение
		Результат.ЕстьОшибки = Истина;
		Результат.ОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

&После("ПередЗаписью")
Процедура бг_ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	Если ЭтоНовый() Тогда
		Возврат;
	КонецЕсли;
	ЗагрузкаИзФайла = ДополнительныеСвойства.Свойство("ЗагрузкаИзФайла");
	Если Не ЗагрузкаИзФайла Тогда
		Движения.бг_ПоказанияПриборовАСИиУ.Прочитать();
	КонецЕсли;
	АктивностьДвижений = (РежимЗаписи = РежимЗаписиДокумента.Проведение)
		Или ((РежимЗаписи = РежимЗаписиДокумента.Запись) И Проведен);
	УстановитьАктивностьДвижений(АктивностьДвижений);
	Движения.бг_ПоказанияПриборовАСИиУ.Записать(Истина);
КонецПроцедуры

&После("ОбработкаЗаполнения")
Процедура бг_ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Ответственный = Пользователи.ТекущийПользователь();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьАктивностьДвижений(ФлагАктивности)
	
	Для Каждого Движение Из Движения Цикл
		
		Движение.УстановитьАктивность(ФлагАктивности);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

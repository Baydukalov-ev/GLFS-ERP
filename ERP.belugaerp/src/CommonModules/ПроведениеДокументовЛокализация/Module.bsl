
#Область ПрограммныйИнтерфейс

&После("СформироватьЗаданияНаОтложенныеДвижения")
Процедура бг_СформироватьЗаданияНаОтложенныеДвижения(Документ, МенеджерВременныхТаблиц) Экспорт

	бг_Факторинг.ДобавитьВОчередьСинхронизацииСвязанныхДокументов(Документ, МенеджерВременныхТаблиц);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&После("ДополнитьУчетныеМеханизмыКонфигурации")
Процедура бг_ДополнитьУчетныеМеханизмыКонфигурации(МеханизмыКонфигурации)
	
	МеханизмыКонфигурации.Вставить("бг_УчетБанковскихГарантий", "бг_УчетБанковскихГарантий");
	МеханизмыКонфигурации.Вставить("бг_СкидкиНаценки", "бг_РасчетСкидок");
	МеханизмыКонфигурации.Вставить("бг_РасчетыСПокупателямиРозница", "бг_РасчетыСПокупателямиРозница");
	МеханизмыКонфигурации.Вставить("бг_РезервыТоваров", "бг_РезервыТоваров");
	МеханизмыКонфигурации.Вставить("бг_Факторинг", "бг_Факторинг");

КонецПроцедуры

#КонецОбласти
